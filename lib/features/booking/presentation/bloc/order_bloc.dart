import 'dart:io';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/core/utils/location/exec_location.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/features/booking/domain/use_cases/get_all_order_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/send_request_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/update_order_usecase.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/domain/use_cases/add_order_usecase.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/categories/data/models/services.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  List<Booking> bookingList = const [];

  AddOrderUseCase addOrderUseCase;
  GetAllOrderUseCase getAllOrderUseCase;
  UpdateOrderUseCase updateOrderUseCase;

  SendRequestUseCase sendRequestUseCase;

  BookingBloc(
      {required this.addOrderUseCase,
      required this.getAllOrderUseCase,
      required this.updateOrderUseCase,
      required this.sendRequestUseCase})
      : super(OrderInitialState()) {
    on<FetchAllOrderEvent>((event, emit) async {
      await getAllOrder(emit);
    });

    on<UpdateBookingServiceListEvent>((event, emit) {
      updateBookingServiceList(event, emit);
    });

    on<AddOrderEvent>((event, emit) async {
      await addNewOrder(event, emit);
      await getAllOrder(emit);
    });

    on<UpdateOrderEvent>((event, emit) async {
      await updateOrder(event, emit);
      await getAllOrder(emit);
    });

    on<CancelOrderEvent>((event, emit) async {
      await cancelOrder(event, emit);
      await getAllOrder(emit);
    });

    on<ChangeCurrentOrdersEvent>((event, emit) {
      changeOrdersType(event, emit);
    });

    on<SetCurrentOrderEvent>((event, emit) {
      setCurrentOrder(event, emit);
    });

    on<FilterOrderByDate>((event, emit) {
      filterOrderByDate(event, emit);
    });

    on<UpdateRequestFormDataEvent>((event, emit) {
      updateRequestForm(event, emit);
    });

    on<SendRequestDataEvent>((event, emit) async {
      await sendRequestFn(event, emit);
    });
  }
  static BookingBloc get(BuildContext context) => BlocProvider.of(context);

  ///collect booking data
  Booking? currentBooking;
  File? patientDocument;
  File? patientDocument2;
  collectNewBookingData(CollectNewBookingDataOrder event, emit) {
    emit(OrderSuccessfullyState());
    currentBooking = Booking(
        week: event.bookingData['week'] ?? currentBooking?.week.toString(),
        day: event.bookingData['day'] ?? currentBooking?.day.toString(),
        hours: event.bookingData['hours'] ?? currentBooking?.hours.toString(),
        area: event.bookingData['area'] ?? currentBooking?.area.toString(),
        date: event.bookingData['date'] ?? currentBooking?.date.toString(),
        desc: event.bookingData['desc'] ?? currentBooking?.desc.toString());
    if (patientDocument != null)
      patientDocument = File(event.bookingData['patientDocument']);
    if (patientDocument2 != null)
      patientDocument2 = File(event.bookingData['patientDocument2']);
    emit(OrderSuccessfullyState());
  }

  filterOrderByDate(FilterOrderByDate event, emit) {
    emit(OrderSuccessfullyState());

    emit(OrderSuccessfullyState());
  }

  ORDER_STATUS currentOrdersType = ORDER_STATUS.ONGOING;
  int currentTapOrdersIndex = 0;
  changeOrdersType(ChangeCurrentOrdersEvent event, emit) {
    emit(OrderLoadingState());
    currentOrdersType = event.type;
    currentTapOrdersIndex = event.index;
    emit(OrderSuccessfullyState());
  }

  List<Booking> getCurrentOrdersByType() {
    // Filter orders by type, but exclude PENDING orders from ONGOING (Current) list
    if (currentOrdersType == ORDER_STATUS.ONGOING) {
      // For current orders, only show ONGOING status (exclude PENDING)
      return bookingList.where((element) {
        var status = OrderModel.getStatusViewCheck(element.status.toString());
        return status == ORDER_STATUS.ONGOING;
      }).toList();
    } else {
      // For other tabs (COMPLETED, etc.), show orders matching the selected type
      return bookingList
          .where((element) =>
              OrderModel.getStatusViewCheck(element.status.toString()) ==
              currentOrdersType)
          .toList();
    }
  }

  getAllOrder(emit) async {
    if (!Util.checkUser()) return;
    emit(OrderLoadingState());
    // try{
    var res = await getAllOrderUseCase();
    res.fold((l) {
      emit(OrderErrorState(errors: l.toString()));
    }, (data) {
      bookingList = data.reversed.toList();
      _executeTracking();
      emit(OrderSuccessfullyState());
    });
    // }catch(e){
    //   debugPrint("getAllOrderBlocError: $e");
    //   emit(OrderErrorState(errors: e.toString()));
    // }
  }

  _executeTracking() {
    if (Util.checkUser() && !Util.isCustomer() && Util.getUserID() != "null") {
      if (checkIfHasCurrentBooking()) {
        onStartTrack();
      } else {
        onStopTrack();
      }
    }
  }

  Booking? currentOrder;
  setCurrentOrder(SetCurrentOrderEvent event, emit) {
    if (event.order == null) return;
    emit(OrderLoadingState());
    currentOrder = event.order;
    emit(OrderSuccessfullyState());
  }

  addNewOrder(AddOrderEvent event, emit) async {
    emit(SendNewBookingRequestLoadingState());
    try {
      var orderData =
          collectOrderData(payment: event.payment, orderData: event.orderData);
      var res = await addOrderUseCase(data: orderData);
      res.fold((l) {
        emit(OrderErrorState(errors: l.toString()));
      }, (data) async {
        if (data.state == true) {
          // Workaround: Update status to PENDING immediately because backend defaults to ONGOING
          if (data.orderID != null && data.orderID!.isNotEmpty) {
            await updateOrderUseCase(
                data: {'booking_id': data.orderID, 'status': 'PENDING'});
          }
          emit(AssignOrderSuccessfullyState());
        } else {
          emit(OrderErrorState(errors: data.msg.toString()));
        }
      });
    } catch (e) {
      debugPrint("addNewOrderError: $e");
      emit(OrderErrorState(errors: e.toString()));
    }
  }

  updateOrder(UpdateOrderEvent event, emit) async {
    emit(OrderLoadingState());
    try {
      var res = await updateOrderUseCase(
        data: event.data,
      );
      res.fold((l) {
        emit(OrderErrorState(errors: l.toString()));
      }, (data) {
        if (data.state == true) {
          if (event.data['status'] == 'CANCELLED') {
            emit(RefuesdOrderSuccessfullyState());
          } else {
            emit(UpdateOrderSuccessfullyState());
          }
        } else {
          emit(OrderErrorState(errors: data.msg.toString()));
        }
      });
    } catch (e) {
      debugPrint("updateOrderError: $e");
      emit(OrderErrorState(errors: e.toString()));
    }
  }

  cancelOrder(CancelOrderEvent event, emit) async {
    emit(OrderLoadingState());
    try {
      // OrderResponse res = await _orderClient.cancelOrder(event.id.toString());
      // if(res.state==true){
      //   emit(OrderSuccessfullyState());
      // }else{
      //   emit(OrderErrorState(errors: res.msg.toString()));
      // }
    } catch (e) {
      debugPrint("addNewOrderError: $e");
      emit(OrderErrorState(errors: e.toString()));
    }
  }

  List<ServicesModel> orderServiceList = [];
  updateBookingServiceList(UpdateBookingServiceListEvent event, emit) {
    emit(OrderLoadingState());
    int index = orderServiceList
        .indexWhere((element) => element.id == event.service.id);
    if (index == -1) {
      orderServiceList.add(event.service);
    } else {
      orderServiceList.removeAt(index);
    }
    emit(OrderSuccessfullyState());
  }

  Map<String, dynamic> collectOrderData(
      {required PaymentOption payment,
      required Map<String, dynamic> orderData}) {
    String desc = "";
    for (var i in orderServiceList) {
      desc += "${i.name}: ${i.value}${translate("icare.le")} ";
    }
    var data = {
      'user_id': Util.getUserID(),
      'nurse_id': orderData['nurse_id'],
      'city': "",
      'payment_type': "cash",
      'payment_status': 'pending',
      'grand_total': "0.0",
      'coupon_discount': "0",
      'arrival_date': "",
      'desc': desc,
      'address': orderData['address'] ?? '',
      'lat': orderData['lat'] ?? '',
      'long': orderData['long'] ?? '',
      'status': 'PENDING',
      'order_status': 'PENDING'
    };
    return data;
  }

  /// NURSE SECTION
  bool checkIfHasCurrentBooking() {
    int checkIndex = bookingList.indexWhere((element) =>
        OrderModel.getStatusViewCheck(element.status.toString()) ==
        ORDER_STATUS.ONGOING);
    return checkIndex != -1;
  }

  //check if booking is ongooing and nurse can not edit
  bool checkIfExistBookingOngoingAndNurseCanNotEdit() {
    int checkIndex = bookingList.indexWhere((element) =>
        OrderModel.getStatusViewCheck(element.status.toString()) ==
            ORDER_STATUS.ONGOING &&
        element.nurseCanEditPatientProfile == false);
    return checkIndex != -1;
  }

  /// Helper methods for booking actions
  Booking? getBookingByOrderId(String? orderId) {
    try {
      return bookingList.firstWhere(
        (e) => e.orderId.toString() == orderId.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  void acceptOrder(Booking booking) {
    add(UpdateOrderEvent(
      data: {
        'booking_id': booking.orderId.toString(),
        'status': 'ONGOING',
      },
    ));
  }

  void refuseOrder(Booking booking) {
    add(UpdateOrderEvent(
      data: {
        'booking_id': booking.orderId.toString(),
        'status': 'CANCELLED',
      },
    ));
  }

  /// [REQUEST_FORM_SECTION]
  Map<String, dynamic> formData = {};
  String rangeNumber = '1';
  String dateVal = 'يوم';
  String movmentLevel = 'قادر علي الحركة';
  String needTO = 'تمريض يومي';
  String moreNeed = 'تغيير الضمادات';
  String gender = 'male';

  updateRequestForm(UpdateRequestFormDataEvent event, emit) {
    emit(const UpdateBookingRequestFormInitialState());
    if (event.data['full_name'] != null)
      formData['full_name'] = event.data['full_name'].toString();
    if (event.data['phone'] != null)
      formData['phone'] = event.data['phone'].toString();
    if (event.data['main_medical'] != null)
      formData['main_medical'] = event.data['main_medical'].toString();
    if (event.data['national_id'] != null)
      formData['national_id'] = event.data['national_id'].toString();
    if (event.data['more_info'] != null)
      formData['more_info'] = event.data['more_info'].toString();

    if (event.data['range_number'] != null)
      rangeNumber = event.data['range_number'].toString();
    if (event.data['date_val'] != null)
      dateVal = event.data['date_val'].toString();
    if (event.data['movment_level'] != null)
      movmentLevel = event.data['movment_level'].toString();
    if (event.data['need_to'] != null)
      needTO = event.data['need_to'].toString();
    if (event.data['more_need'] != null)
      moreNeed = event.data['more_need'].toString();
    if (event.data['gender'] != null) gender = event.data['gender'].toString();
    emit(const UpdateBookingRequestFormSuccessfullyState());
  }

  validateForm(emit) {
    if (formData.entries.isEmpty) {
      emit(SendBookingRequestFialedState(msg: translate('toast.empty')));
      return false;
    }
    if (formData['full_name'] == null) {
      emit(SendBookingRequestFialedState(
          msg:
              "${translate('toast.empty')} [ ${translate('signup.full_name')} ]"));
      return false;
    }
    if (formData['phone'] == null) {
      emit(SendBookingRequestFialedState(
          msg: "${translate('toast.empty')} [ ${translate('signup.phone')} ]"));
      return false;
    }
    if (formData['main_medical'] == null) {
      emit(SendBookingRequestFialedState(
          msg:
              "${translate('toast.empty')} [ ${translate('signup.main_medical')} ]"));
      return false;
    }
    if (formData['national_id'] == null) {
      emit(SendBookingRequestFialedState(
          msg:
              "${translate('toast.empty')} [ ${translate('signup.national_id')} ]"));
    }
    if (formData['more_info'] == null) {
      emit(SendBookingRequestFialedState(
          msg:
              "${translate('toast.empty')} [ ${translate('icare.more_info')} ]"));
      return false;
    }
    return true;
  }

  sendRequestFn(SendRequestDataEvent event, emit) async {
    if (validateForm(emit) != true) return;
    emit(const SendBookingRequestLoadingState());
    try {
      var res = await sendRequestUseCase(data: {
        'phone': formData['phone'] ?? '',
        'main_medical': formData['main_medical'] ?? '',
        'national_id': formData['national_id'] ?? '',
        'more_info': formData['more_info'] ?? '',
        'range_number': rangeNumber,
        'date_val': dateVal,
        'movment_level': movmentLevel,
        'need_to': needTO,
        'more_need': moreNeed,
        'gender': gender,
      });
      res.fold((l) {
        emit(SendBookingRequestFialedState(msg: l.toString()));
      }, (data) {
        if (data.state == true) {
          emit(const SendBookingRequestFormSuccessfullyState());
        } else {
          emit(SendBookingRequestFialedState(msg: data.msg.toString()));
        }
      });
    } catch (e) {
      debugPrint("sendRequestFnError: $e");
      emit(SendBookingRequestFialedState(msg: e.toString()));
    }
  }
}
