import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallRowHomeWidget extends StatelessWidget {
  final String? imgPath;
  final String title, desc;
  final Icon? iconButton;
  final VoidCallback fn;
  const SmallRowHomeWidget(
      {super.key,
      this.imgPath,
      required this.fn,
      required this.title,
      required this.desc,
      this.iconButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (iconButton != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 5),
                      child: iconButton,
                    ),
                  if (imgPath != null)
                    Image.asset(
                      imgPath!,
                      height: 35.h,
                      width: 30.w,
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(
                    width: 35,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
                color: Colors.black45,
                height: 10,
              ),
            ],
          )),
    );
  }
}
