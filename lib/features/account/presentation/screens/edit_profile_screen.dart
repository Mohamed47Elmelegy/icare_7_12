// ignore_for_file: use_build_context_synchronously

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/screens/emergency_number_widget.dart';
import 'package:icare/features/account/presentation/widgets/secure_info.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_event.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';
import 'package:icare/features/locations/presentation/widgets/city_list_drop_down.dart';
import 'package:icare/features/locations/presentation/widgets/current_location.dart';
import 'package:icare/features/locations/presentation/widgets/governorate_type_drop_down.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController cityTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();

  late AccountBloc accountBloc;
  late LocationsBloc locationsBloc;

  @override
  void didChangeDependencies() {
    locationsBloc = LocationsBloc.get(context);
    accountBloc = AccountBloc.get(context);
    var user = accountBloc.currentUser;
    if (user != null) {
      firstNameTextEditingController.text =
          user.userName.toString().replaceAll("null", "");
      emailTextEditingController.text =
          user.email.toString().replaceAll("null", "");
      phoneTextEditingController.text =
          user.phoneNumber.toString().replaceAll("null", "");
      if (user.governorate != null && user.governorate != "") {
        var governoratesList = RootBloc.get(context).governoratesList;
        int governorateIndex = governoratesList.indexWhere((element) =>
            element.title.trim() == user.governorate.toString().trim() ||
            element.id.toString() == user.governorate);
        if (governorateIndex != -1) {
          locationsBloc.add(UpdateCurrentLocationEvent(
              governorate:
                  governoratesList[governorateIndex].title.toString()));
        }
      }
      if (user.cityID != null && user.cityID != "") {
        var cityList = RootBloc.get(context).citiesList;
        int cityIndex = cityList.indexWhere((element) =>
            element.title.trim() == user.cityID.toString().trim() ||
            element.id.toString() == user.cityID);
        if (cityIndex != -1) {
          locationsBloc.add(UpdateCurrentLocationEvent(
              city: cityList[cityIndex].title.toString()));
        }
      }
      locationsBloc.add(UpdateCurrentLocationEvent(
          location: LocationEntity(
              address1: user.address.toString(),
              address2: user.address.toString(),
              country: user.countryCode.toString(),
              phone: user.phoneNumber.toString(),
              id: 1,
              type: "auth",
              long: double.tryParse(user.long.toString()) ?? 0,
              lat: double.tryParse(user.lat.toString()) ?? 0,
              state: "",
              firstName: "",
              lastName: "",
              email: "",
              postCode: "")));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (ctx, state) {
        if (state is UpdateProfileState) {
          if (state.response.isSuccess == true) {
            SnackBarBuilder.showFeedBackMessage(
                context, translate("toast.update_user_data"), Colors.green);
          }
          if (state.response.isFailed == true) {
            SnackBarBuilder.showFeedBackMessage(
                context, translate("toast.oops"), Colors.red);
          }
        }
      },
      listenWhen: (ctx, state) {
        return state is UpdateProfileState;
      },
      child: Scaffold(
        appBar: GlobalAppBar(
          backGroundColor: DMUtil.getWC(),
          title: translate("profile.profile"),
          whiteLogo: true,
          leadingIcon: BackArrowButton(
            color: DMUtil.getPC(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            AccountBloc bloc = AccountBloc.get(ctx);
            // if(states==FetchStates.FAILED) return const Center(child: Text("an error occurred"),);
            if (state is UpdateProfileState && state.response.isLoad == true) {
              return CircularProgressIndicator(
                color: DMUtil.getPC(),
              );
            }
            return BlocBuilder<LocationsBloc, LocationsState>(
              builder: (ctx, state) {
                var locationBloc = LocationsBloc.get(ctx);
                var currentLocation = locationBloc.currentCheckOutLocation;
                return CustomButton(
                  height: 40.h,
                  width: 300.w,
                  circular: 10,
                  widget: CustomText(
                    color: Colors.white,
                    fontSize: AppStyle.average.sp,
                    fontFamily: primaryFontBold,
                    text: translate("profile.save_changes"),
                  ),
                  color: DMUtil.getPC(),
                  onPressed: () async {
                    if (emailTextEditingController.text.trim().isNotEmpty &&
                        firstNameTextEditingController.text.trim().isNotEmpty &&
                        phoneTextEditingController.text.trim().isNotEmpty) {
                      bloc.add(UpdateProfileEvent(user: {
                        'profile': 'update',
                        "phone": phoneTextEditingController.text.trim(),
                        "email": emailTextEditingController.text.trim(),
                        "name": firstNameTextEditingController.text.trim(),
                        if (currentLocation != null &&
                            locationsBloc.governorate != null)
                          "governorate": locationsBloc.governorate,
                        if (currentLocation != null &&
                            locationsBloc.city != null)
                          "city": locationsBloc.city,
                        if (currentLocation != null)
                          "address":
                              "${currentLocation.address1} ${currentLocation.address2}",
                        if (currentLocation != null &&
                            currentLocation.postCode != "")
                          "postal_code": currentLocation.postCode.toString(),
                        if (currentLocation != null && currentLocation.lat != 0)
                          "latitude": currentLocation.lat.toString(),
                        if (currentLocation != null &&
                            currentLocation.long != 0)
                          "longitude": currentLocation.long.toString(),
                      }));
                    } else {
                      return SnackBarBuilder.showFeedBackMessage(
                          context, translate("toast.field_empty"), Colors.red);
                    }
                  },
                );
              },
            );
          },
        ),
        backgroundColor: DMUtil.getWC(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyle.paddingFromH.w, vertical: 15),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CustomTextFromField(
                hasBorder: true,
                borderWidth: 1,
                borderColor: DMUtil.getD2C(),
                labelText: '',
                height: 45,
                hintText: translate("signup.username"),
                radius: 10,
                onChanged: (val) {},
                onFieldSubmitted: (val) {},
                textEditingController: firstNameTextEditingController,
                cursorColor: kPrimary,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                suffixIcon: Icon(
                  Icons.person,
                  color: DMUtil.getPC(),
                  size: 20.w,
                ),
                isLabelError: false,
              ),
              SizedBox(
                height: 10.w,
              ),
              GenderRow(
                txtColor: DMUtil.getD2C(),
              ),
              SizedBox(
                height: 10.w,
              ),
              CustomTextFromField(
                hasBorder: true,
                borderWidth: 1,
                borderColor: DMUtil.getD2C(),
                labelText: '',
                height: 45,
                hintText: translate("signup.phone"),
                radius: 10,
                onChanged: (val) {},
                onFieldSubmitted: (val) {},
                textInputType: TextInputType.phone,
                textEditingController: phoneTextEditingController,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                suffixIcon: Icon(
                  Icons.phone,
                  color: DMUtil.getPC(),
                  size: 20.w,
                ),
                isLabelError: false,
              ),
              // IntlPhoneField(
              //   controller: phoneTextEditingController,
              //   decoration: InputDecoration(
              //     labelText:  translate("signup.phone"),
              //     labelStyle: TextStyle(color: DMUtil.getD2C()),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: BorderSide(
              //           width: 1,color: DMUtil.getOpacity()
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: BorderSide(
              //           width: 1,color: DMUtil.getOpacity()
              //       ),
              //     ),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           width: 1,color: DMUtil.getOpacity()
              //       ),
              //     ),
              //   ),
              //   initialCountryCode: 'EG',
              //   onChanged: (phone) {
              //   },
              // ),
              SizedBox(
                height: 10.w,
              ),
              CustomTextFromField(
                hasBorder: true,
                borderWidth: 1,
                borderColor: DMUtil.getD2C(),
                labelText: '',
                height: 45,
                hintText: translate("signup.email"),
                radius: 10,
                onChanged: (val) {},
                onFieldSubmitted: (val) {},
                textEditingController: emailTextEditingController,
                cursorColor: kPrimary,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                suffixIcon: Icon(
                  Icons.email,
                  color: DMUtil.getPC(),
                  size: 20.w,
                ),
                isLabelError: false,
              ),

              SizedBox(
                height: 10.w,
              ),
              const GovernorateListDropDown(),
              SizedBox(
                height: 10.w,
              ),
              const CityListDropDown(),
              SizedBox(
                height: 10.w,
              ),
              const CurrentLocationDetails(),

              // if(!Util.isCustomer())...[
              Divider(
                height: 40.w,
              ),
              const EmergencyNumberWidget(),
              const SizedBox(
                height: 70,
              ),
              // ],

              Divider(
                height: 40.w,
              ),
              const SecureInfo(),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearData() {
    firstNameTextEditingController.text = "";
    emailTextEditingController.text = "";
    phoneTextEditingController.text = "";
  }

  bool validatePhoneInput(String phone, BuildContext context) {
    if (phone.isNotEmpty) {
      String? txt = Util.validatePhone(phone);
      if (txt != null) {
        SnackBarBuilder.showFeedBackMessage(context, txt, DMUtil.getRED());
        return false;
      }
    }
    return true;
  }
}
