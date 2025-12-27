import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/presentation/widgets/vertical_specialist_card.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class AllProvidersScreen extends StatefulWidget {
  const AllProvidersScreen({super.key});

  @override
  State<AllProvidersScreen> createState() => _AllProvidersScreenState();
}

class _AllProvidersScreenState extends State<AllProvidersScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch ongoing bookings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BookingBloc.get(context).add(const GetOngoingBookingsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getPC(),
        title: translate("search.all_providers"),
        textColor: DMUtil.getWC(),
        whiteLogo: true,
        leadingIcon: BackArrowButton(color: DMUtil.getWC()),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: DMUtil.getPC(),
              ),
            );
          }

          if (state is SearchErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: state.message,
                    fontSize: AppStyle.average.sp,
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }

          if (state is SearchSuccessState) {
            if (state.results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64.w,
                      color: DMUtil.getD2C(),
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: translate("search.no_results"),
                      fontSize: AppStyle.average.sp,
                      color: DMUtil.getD2C(),
                    ),
                  ],
                ),
              );
            }

            // Remove duplicates based on provider ID
            final uniqueResults = <int, SearchableEntity>{};
            for (var provider in state.results) {
              if (provider.userData?.userId != null) {
                uniqueResults[provider.userData!.userId!] = provider;
              }
            }
            var uniqueProviders = uniqueResults.values.toList();

            // Filter out specialists with ongoing bookings
            final bookingBloc = BookingBloc.get(context);
            final bookedIds = bookingBloc.getOngoingBookedProviderIds();
            if (bookedIds.isNotEmpty) {
              uniqueProviders = uniqueProviders.where((provider) {
                final providerId = provider.userData?.userId;
                return providerId == null || !bookedIds.contains(providerId);
              }).toList();
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Refresh ongoing bookings and search results
                final bookingBloc = BookingBloc.get(context);
                bookingBloc.add(const GetOngoingBookingsEvent());

                final searchBloc = SearchBloc.get(context);
                final filters = searchBloc.getCurrentFilters();
                searchBloc.add(
                  SearchByFiltersEvent(filters: filters),
                );
              },
              color: DMUtil.getPC(),
              child: Column(
                children: [
                  // Results count header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: DMUtil.getPC().withOpacity(0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: DMUtil.getD2C().withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text:
                              '${translate("search.found")} ${uniqueProviders.length} ${translate("search.results")}',
                          fontSize: AppStyle.average.sp,
                          fontWeight: FontWeight.w600,
                          color: DMUtil.getPC(),
                        ),
                        Icon(
                          Icons.filter_list,
                          size: 20.w,
                          color: DMUtil.getPC(),
                        ),
                      ],
                    ),
                  ),

                  // Providers list
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppStyle.paddingFromH.w,
                        vertical: 10.h,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: uniqueProviders.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final provider = uniqueProviders[index];

                        // Type check and cast to NurseEntity
                        if (provider is NurseEntity) {
                          return VerticalSpecialistCard(nurse: provider);
                        }

                        // TODO: Handle DoctorEntity with a DoctorCard widget
                        // For now, return an empty container for non-nurse providers
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          // Initial state or no search performed yet
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64.w,
                  color: DMUtil.getD2C(),
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: translate("search.please_search_first"),
                  fontSize: AppStyle.average.sp,
                  color: DMUtil.getD2C(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
