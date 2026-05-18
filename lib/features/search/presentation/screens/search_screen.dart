import 'package:flutter/material.dart';
import 'package:icare/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/search/presentation/screens/map_search_screen.dart';
import 'package:icare/features/search/presentation/screens/all_providers_screen.dart';
import 'package:icare/features/search/presentation/widgets/provider_type_selector.dart';
import 'package:icare/features/search/presentation/widgets/search_list.dart';
import 'package:icare/features/search/presentation/widgets/service_selector.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/logo_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ExpansibleController _expansionTileController = ExpansibleController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        // Reload services when provider type changes
        if (state is ProviderTypeSelectedState) {
          context
              .read<ServicesBloc>()
              .add(FetchAllServicesEvent(userType: state.providerType));
          AppLogger.d("🔄 Reloading services for: ${state.providerType}");
        }

        if (state is SearchSuccessState) {
          SnackBarBuilder.showFeedBackMessage(
            context,
            '${translate("search.found")} ${state.results.length} ${translate("search.results")}',
            Colors.green,
          );
        } else if (state is SearchErrorState) {
          SnackBarBuilder.showFeedBackMessage(
            context,
            state.message,
            Colors.red,
          );
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const MapSearchScreen(
            isSet: false,
          ),
          Container(
            height: 180.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w, vertical: 10),
            decoration: BoxDecoration(color: DMUtil.getPC()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: translate("search.search"),
                  color: DMUtil.getWC(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.large.sp,
                ),
                SizedBox(
                  height: 20.w,
                ),
                const LogoWidget(
                  width: 100,
                  height: 53,
                  isWhite: true,
                ),
              ],
            ),
          ),
          Positioned(
            top: 110.w,
            child: Container(
              width: 320.w,
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.paddingFromH.w, vertical: 15.h),
              decoration: BoxDecoration(
                  color: DMUtil.getWC(),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Service Selector
                  ServiceSelector(controller: _expansionTileController),
                  SizedBox(height: 10.h),

                  // Divider
                  Divider(
                    color: DMUtil.getD2C().withValues(alpha: 0.2),
                    height: 1,
                  ),
                  SizedBox(height: 10.h),

                  // // Location Search Field
                  // CustomTextFromField(
                  //   hasBorder: true,
                  //   borderWidth: 1,
                  //   borderColor: DMUtil.getD2C().withValues(alpha:0.3),
                  //   labelText: '',
                  //   height: 50,
                  //   hintText: translate("search.select_area"),
                  //   radius: 10,
                  //   onChanged: (val) => RootBloc.get(context)
                  //       .add(SearchEvent(word: val.toString().trim())),
                  //   onFieldSubmitted: (val) =>
                  //       RootBloc.get(context).add(const SearchEvent(word: "")),
                  //   textEditingController: searchTextEditingController,
                  //   validator: () {},
                  //   prefixIcon: Icon(
                  //     Icons.location_on_outlined,
                  //     size: 20.w,
                  //     color: DMUtil.getPC(),
                  //   ),
                  //   suffixIcon: null,
                  //   isLabelError: false,
                  //   obscureText: false,
                  // ),
                  // SizedBox(height: 15.h),

                  SizedBox(height: 10.h),

                  // Provider Type Selector
                  ProviderTypeSelector(
                      selectedColor: DMUtil.getPC(), txtColor: DMUtil.getD2C()),
                  SizedBox(height: 15.h),

                  // Search Button
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      final isLoading = state is SearchLoadingState;

                      return Row(
                        children: [
                          // Search Button
                          Expanded(
                            child: SizedBox(
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final searchBloc =
                                            SearchBloc.get(context);

                                        // Validate that provider type is selected (required)
                                        if (searchBloc.selectedProviderType ==
                                            null) {
                                          SnackBarBuilder.showFeedBackMessage(
                                            context,
                                            translate(
                                                "search.please_select_provider_type"),
                                            Colors.orange,
                                          );
                                          return;
                                        }

                                        // Validate that at least one service is selected (required)
                                        if (searchBloc
                                            .selectedServices.isEmpty) {
                                          SnackBarBuilder.showFeedBackMessage(
                                            context,
                                            translate(
                                                "search.please_select_service"),
                                            Colors.orange,
                                          );
                                          return;
                                        }

                                        // Get current filters
                                        final filters =
                                            searchBloc.getCurrentFilters();

                                        // Trigger search
                                        searchBloc.add(SearchByFiltersEvent(
                                            filters: filters));

                                        // Close the service dropdown if open
                                        if (_expansionTileController
                                            .isExpanded) {
                                          _expansionTileController.collapse();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DMUtil.getPC(),
                                  foregroundColor: DMUtil.getWC(),
                                  elevation: 2,
                                  disabledBackgroundColor:
                                      DMUtil.getPC().withValues(alpha: 0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 24.h,
                                        width: 24.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            DMUtil.getWC(),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search,
                                            size: 24.w,
                                            color: DMUtil.getWC(),
                                          ),
                                          SizedBox(width: 10.w),
                                          CustomText(
                                            text: translate("search.search"),
                                            fontSize: AppStyle.average.sp,
                                            fontWeight: FontWeight.w600,
                                            color: DMUtil.getWC(),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // List Icon Button
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: DMUtil.getWC(),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: DMUtil.getPC(),
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllProvidersScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.list,
                                size: 24.w,
                                color: DMUtil.getPC(),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 180.w,
            child: const SearchListWidget(),
          ),
        ],
      ),
    );
  }
}
