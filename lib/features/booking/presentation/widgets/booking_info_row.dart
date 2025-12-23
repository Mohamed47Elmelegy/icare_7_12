import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/booking/presentation/widgets/booking_info_column.dart';

/// Reusable row widget for displaying two label-value pairs side by side
class BookingInfoRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const BookingInfoRow({
    super.key,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (label1.isNotEmpty)
          Expanded(
            child: BookingInfoColumn(label: label1, value: value1),
          ),
        if (label2.isNotEmpty) ...[
          SizedBox(width: 16.w),
          Expanded(
            child: BookingInfoColumn(label: label2, value: value2),
          ),
        ],
      ],
    );
  }
}
