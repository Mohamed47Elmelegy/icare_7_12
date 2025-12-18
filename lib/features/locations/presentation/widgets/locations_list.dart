import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_event.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';
import 'package:icare/features/locations/presentation/widgets/location_card.dart';

class LocationsList extends StatelessWidget {
  const LocationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      color: kPrimary,
      child: BlocBuilder<LocationsBloc, LocationsState>(
        builder: (ctx, state) {
          var bloc = LocationsBloc.get(ctx);
          var list = bloc.userLocationsList;
          var localList = bloc.localUserLocationsList;
          if (state is LocationsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimary,
              ),
            );
          }
          // if(bloc.userLocationsList.isEmpty)return const LocationsEmpty();
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w, vertical: 10),
            child: Column(
              children: [
                if (list!.shippingAddress != null)
                  LocationCardWidget(
                      locationEntity: list.shippingAddress!,
                      currentLocation: bloc.currentCheckOutLocation?.id ==
                              list.shippingAddress?.id &&
                          bloc.currentCheckOutLocation?.type == "shipping",
                      isAdd: bloc.checkIFAddressEmpty(list.shippingAddress!)),
                const SizedBox(
                  height: 20,
                ),
                if (list.billingAddress != null)
                  LocationCardWidget(
                      locationEntity: list.billingAddress!,
                      currentLocation: bloc.currentCheckOutLocation?.id ==
                              list.billingAddress?.id &&
                          bloc.currentCheckOutLocation?.type == "billing",
                      isAdd: bloc.checkIFAddressEmpty(list.billingAddress!)),
                if (localList.isNotEmpty) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      var item = localList[index];
                      return LocationCardWidget(
                          locationEntity: item,
                          currentLocation:
                              bloc.currentCheckOutLocation != null &&
                                  bloc.currentCheckOutLocation?.id == item.id &&
                                  bloc.currentCheckOutLocation?.type == "local",
                          isAdd: bloc.checkIFAddressEmpty(item));
                    },
                    separatorBuilder: (ctx, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: localList.length,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future _onRefresh(BuildContext context) async {
    LocationsBloc.get(context).add(const FetchUserLocationsEvent());
  }
}
