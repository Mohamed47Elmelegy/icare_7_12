import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/vertical_specialist_card.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalSpecialistsList extends StatefulWidget {
  const VerticalSpecialistsList({super.key});

  @override
  State<VerticalSpecialistsList> createState() =>
      _VerticalSpecialistsListState();
}

class _VerticalSpecialistsListState extends State<VerticalSpecialistsList> {
  @override
  void initState() {
    super.initState();
    // Fetch ongoing bookings when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BookingBloc.get(context).add(const GetOngoingBookingsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        if (state is FetchNotificationsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          );
        }
        if (state is! FetchNotificationsLoadingState &&
            bloc.nursesList.isEmpty) {
          return const EmptyDataWidget();
        }
        var list = bloc.nursesList;
        if (bloc.searchText != '') {
          list = bloc.nursesList
              .where((v) =>
                  v.userData != null &&
                  v.userData!.userName
                      .toString()
                      .toLowerCase()
                      .trim()
                      .startsWith(bloc.searchText.toLowerCase()))
              .toList();
        }

        // Sort by distance (nearest first)
        list.sort((a, b) {
          // Handle null or invalid distances - put them at the end
          final aDistance = (a.distanceKM != null && a.distanceKM != -1)
              ? a.distanceKM!
              : double.infinity;
          final bDistance = (b.distanceKM != null && b.distanceKM != -1)
              ? b.distanceKM!
              : double.infinity;

          return aDistance.compareTo(bDistance);
        });

        // Remove duplicates based on user ID
        final uniqueNurses = <int, NurseEntity>{};
        for (var nurse in list) {
          if (nurse.userData?.userId != null) {
            uniqueNurses[nurse.userData!.userId!] = nurse;
          }
        }
        list = uniqueNurses.values.toList();

        // Filter out specialists with ongoing bookings
        final bookingBloc = BookingBloc.get(context);
        final bookedIds = bookingBloc.getOngoingBookedProviderIds();
        if (bookedIds.isNotEmpty) {
          list = list.where((nurse) => !bookedIds.contains(nurse.id)).toList();
        }

        return Scrollbar(
          child: ListView.separated(
            itemCount: list.length,
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w, vertical: 70.h),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var item = list[index];
              if (item.userData == null) return const SizedBox.shrink();
              return VerticalSpecialistCard(
                nurse: item,
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: list[index].userData == null ? 0 : 5.w,
            ),
          ),
        );
      },
    );
  }
}
