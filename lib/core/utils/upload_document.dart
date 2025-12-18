// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

getImage({required BuildContext ctx}) async {
  return await showDialog(
      context: ctx,
      builder: (ctX) {
        return AlertDialog(
          content: SizedBox(
            height: 150.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AlignChildRow(
                  isStart: true,
                  child: InkWell(
                    onTap: () => Navigator.pop(ctX),
                    child: const CircleAvatar(
                      backgroundColor: kPrimary,
                      radius: 14,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            Navigator.pop(ctX, File(image.path));
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomText(
                              text: translate("order.upload_photo"),
                              color: kText1,
                              fontSize: AppStyle.small.sp,
                              fontFamily: primaryFontSemiBold,
                              alignCenter: true,
                            ),
                          ],
                        )),
                    InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera);
                          if (photo != null) {
                            Navigator.pop(ctX, File(photo.path));
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 50.w,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomText(
                              text: translate("order.take_photo"),
                              color: kText1,
                              fontSize: AppStyle.small.sp,
                              fontFamily: primaryFontSemiBold,
                              alignCenter: true,
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

Future<File?> cropImage(File file) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: file.path,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 100,
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: kPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ],
  );
  return croppedFile == null ? null : File(croppedFile.path);
}
