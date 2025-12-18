import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAppBarIcons extends StatelessWidget {
  const ProfileAppBarIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const NotificationIcon(),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          child: Icon(
            CupertinoIcons.home,
            color: DMUtil.getWC(),
            size: 19.w,
          ),
        ),
      ],
    );
  }
}
