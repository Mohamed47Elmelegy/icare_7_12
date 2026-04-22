import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';

class EditIcon extends StatelessWidget {
  const EditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.w, right: 5, left: 5),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              width: 1, color: DMUtil.getDC().withValues(alpha: 0.4))),
      child: Icon(
        Icons.edit,
        color: DMUtil.getDC().withValues(alpha: 0.6),
        size: 17.w,
      ),
    );
  }
}
