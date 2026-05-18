import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';
import 'package:icare/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ReportTapScreen extends StatefulWidget {
  final bool? isNurseEditMode;
  final GlobalKey<TodayMonitoringVitalsState>? vitalsKey;
  const ReportTapScreen(
      {super.key, this.isNurseEditMode = false, this.vitalsKey});

  @override
  State<ReportTapScreen> createState() => _ReportTapScreenState();
}

class _ReportTapScreenState extends State<ReportTapScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch medical reports when screen loads
    if (Util.checkUser()) {
      final accountBloc = AccountBloc.get(context);
      // Use the currentUser from AccountBloc which is set to the patient when nurse enters their profile
      final patientId =
          accountBloc.currentUser?.userId?.toString() ?? Util.getUserID();
      AppLogger.d(
          "📡 [ReportTap] Fetching medical reports for patient: $patientId");
      accountBloc.add(FetchPatientMedicalReportsEvent(patientId: patientId));
    }
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper method to parse date string and compare
  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      // Try different date formats
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        // Try parsing with DateFormat if the format is different
        return DateFormat('yyyy-MM-dd').parse(dateString);
      } catch (e2) {
        AppLogger.e("DEBUG: Error parsing date: $dateString - $e2");
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate("profile.medical_conditions"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            var allOrders = BookingBloc.get(context).bookingList;
            final accountBloc = AccountBloc.get(context);
            final patientId = accountBloc.currentUser?.userId;

            // Filter orders by patient ID
            var orders = allOrders.where((o) => o.userId == patientId).toList();

            Booking? latestBooking;
            try {
              if (orders.isNotEmpty) {
                var completedOrders = orders
                    .where((o) =>
                        o.status == "COMPLETED" ||
                        o.status == "wc-completed" ||
                        o.status == "DELIVERED")
                    .toList();

                if (completedOrders.isNotEmpty) {
                  completedOrders.sort(
                      (a, b) => (b.orderId ?? 0).compareTo(a.orderId ?? 0));
                  latestBooking = completedOrders.first;
                }
              }
            } catch (e) {
              AppLogger.e("DEBUG: Error finding latest booking: $e");
            }

            // Get filtered reports for selected date
            final allReports = accountBloc.patientMedicalReports;
            final selectedDateReports = allReports.where((report) {
              final reportDate = _parseDate(report.createdAt);
              return _isSameDay(reportDate, _selectedDate);
            }).toList();

            return TodayMonitoringVitals(
              key: widget.vitalsKey,
              isNurseEditMode: widget.isNurseEditMode ?? false,
              latestBooking: latestBooking,
              selectedDateReports: selectedDateReports,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        CustomText(
          text: translate("profile.reports_history"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 10,
        ),
        // Calendar Widget
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: DMUtil.getWC(),
            border: Border.all(
              color: DMUtil.getD2C().withValues(alpha: 0.2),
            ),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => _isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.week,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: AppStyle.small.sp,
                fontWeight: FontWeight.w600,
                color: DMUtil.getDC(),
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: DMUtil.getDC(),
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: DMUtil.getDC(),
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: DMUtil.getPC().withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: DMUtil.getPC(),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayTextStyle: TextStyle(
                color: DMUtil.getDC(),
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: TextStyle(
                color: DMUtil.getDC(),
              ),
              weekendTextStyle: TextStyle(
                color: DMUtil.getDC(),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // Selected Date Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: DMUtil.getPC().withValues(alpha: 0.1),
          ),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     CustomText(
          //       text:
          //           "${translate("profile.selected_date")}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
          //       fontSize: AppStyle.small.sp - 1,
          //       fontWeight: FontWeight.w500,
          //       color: DMUtil.getDC(),
          //     ),
          //   ],
          // ),
        ),
        const SizedBox(
          height: 10,
        ),
        // BlocBuilder<AccountBloc, AccountState>(
        //   builder: (context, state) {
        //     final accountBloc = AccountBloc.get(context);
        //     final allReports = accountBloc.patientMedicalReports;

        //     // Filter reports by selected date
        //     final reports = allReports.where((report) {
        //       final reportDate = _parseDate(report.createdAt);
        //       return _isSameDay(reportDate, _selectedDate);
        //     }).toList();

        //     if (state is MedicalReportLoadingState) {
        //       return Center(
        //         child: CircularProgressIndicator(
        //           color: DMUtil.getPC(),
        //         ),
        //       );
        //     }

        //     if (reports.isEmpty) {
        //       return Container(
        //         padding: const EdgeInsets.all(16),
        //         decoration: BoxDecoration(
        //           borderRadius: const BorderRadius.all(Radius.circular(10)),
        //           color: DMUtil.getWC(),
        //         ),
        //         child: Center(
        //           child: CustomText(
        //             text:
        //                 "${translate("profile.no_reports_for_date")} ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
        //             fontSize: AppStyle.small.sp,
        //             color: DMUtil.getD2C(),
        //           ),
        //         ),
        //       );
        //     }

        //     return ListView.separated(
        //       shrinkWrap: true,
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemCount: reports.length,
        //       separatorBuilder: (context, index) => const SizedBox(height: 10),
        //       itemBuilder: (context, index) {
        //         final report = reports[index];
        //         return Container(
        //           padding: const EdgeInsets.all(12),
        //           decoration: BoxDecoration(
        //             borderRadius: const BorderRadius.all(Radius.circular(10)),
        //             color: DMUtil.getWC(),
        //             border: Border.all(
        //               color: DMUtil.getD2C().withValues(alpha:0.2),
        //             ),
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   CustomText(
        //                     text: report.createdAt ?? "",
        //                     fontSize: AppStyle.small.sp - 1,
        //                     fontWeight: FontWeight.w600,
        //                     color: DMUtil.getDC(),
        //                   ),
        //                   if (report.createdByName != null)
        //                     CustomText(
        //                       text: "By: ${report.createdByName}",
        //                       fontSize: AppStyle.small.sp - 2,
        //                       color: DMUtil.getD2C(),
        //                     ),
        //                 ],
        //               ),
        //               const SizedBox(height: 8),
        //               Row(
        //                 children: [
        //                   Expanded(
        //                     child: _buildVitalInfo(
        //                       "HR",
        //                       report.heartRate ?? "-",
        //                     ),
        //                   ),
        //                   Expanded(
        //                     child: _buildVitalInfo(
        //                       "BP",
        //                       report.bloodPressure ?? "-",
        //                     ),
        //                   ),
        //                   Expanded(
        //                     child: _buildVitalInfo(
        //                       "Pulse",
        //                       report.pulseRate ?? "-",
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
      ],
    );
  }
}
