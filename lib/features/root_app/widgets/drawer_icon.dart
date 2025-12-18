import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerIcon extends StatelessWidget {
  final BuildContext ctx;
  final Color? color;
  const DrawerIcon({super.key, required this.ctx, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Scaffold.of(ctx).openDrawer(),
      child: Icon(
        Icons.menu,
        size: 20.w,
      ),
    );
  }
}
