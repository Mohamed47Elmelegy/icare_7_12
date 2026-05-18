import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/core/utils/upload_document.dart';
import 'package:icare/features/authentication/presentation/cubit/registration_cubit.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class AppBarNurseCreateAccount extends StatelessWidget {
  final bool showCircleImg;
  const AppBarNurseCreateAccount({super.key, this.showCircleImg = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const AppBarWithRadius(
          enableBackIcon: true,
          paddingBottom: 90,
          isRegisterNurse: true,
          switchLang: true,
        ),
        Positioned(
            top: 100.w,
            right: Util.getLang() == "ar" ? 10.w : 0,
            left: Util.getLang() != "ar" ? 10.w : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: translate("drawer.join_us"),
                  color: DMUtil.getWC(),
                  fontSize: AppStyle.small.sp,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: translate("signup.signup"),
                  color: DMUtil.getWC(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.large.sp,
                ),
              ],
            )),
        if (showCircleImg)
          Positioned(
              top: 90.w,
              child: BlocBuilder<RegistrationCubit, RegistrationState>(
                builder: (ctx, regState) {
                  var regCubit = RegistrationCubit.get(ctx);
                  return InkWell(
                    onTap: () async {
                      final res = await getImage(ctx: context);
                      if (res != null) {
                        final file = await cropImage(res);
                        if (file != null) {
                          // Avatar is registration data → stored in RegistrationCubit
                          regCubit.updateAvatar(file);
                        }
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        if (regState.avatar != null) ...[
                          CircleAvatar(
                            radius: 55.w,
                            backgroundColor: Colors.transparent,
                            backgroundImage: FileImage(
                              regState.avatar!,
                            ),
                          ),
                        ] else ...[
                          CircleAvatar(
                            radius: 55.w,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(
                              AppImages.nurseImg,
                            ),
                          ),
                        ],
                        const Icon(Icons.upload),
                      ],
                    ),
                  );
                },
              )),
      ],
    );
  }
}
