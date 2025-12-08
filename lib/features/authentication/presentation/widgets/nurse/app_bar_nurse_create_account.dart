import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/core/utils/upload_document.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class AppBarNurseCreateAccount extends StatelessWidget {
  final bool showCircleImg;
  const AppBarNurseCreateAccount({super.key,this.showCircleImg = true});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.center,
      children: [
        const AppBarWithRadius(enableBackIcon: true,paddingBottom: 90,isRegisterNurse: true,switchLang: true,),
        Positioned(
            top: 100.w,
            right: Util.getLang()=="ar"? 10.w:0,
            left: Util.getLang()!="ar"? 10.w:0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: translate("drawer.join_us"),
                  color: DMUtil.getWC(),
                  fontSize: AppStyle.small.sp,
                ),
                const SizedBox(height: 10,),
                CustomText(
                  text: translate("signup.signup"),
                  color: DMUtil.getWC(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.large.sp,
                ),
              ],
            )
        ),

        if(showCircleImg)
        Positioned(
          top: 90.w,
          child: BlocBuilder<AuthBloc,AuthState>(
            builder: (ctx,state){
              var bloc = AuthBloc.get(ctx);
              return InkWell(
                onTap: ()async{
                  final res = await getImage(ctx: context);
                  if(res!=null){
                    final file = await cropImage(res);
                    if(file!=null)bloc.add(UpdateNurseRegisterDataEvent(avatar: file));
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    if(bloc.avatar!=null) ...[
                      CircleAvatar(
                        radius: 55.w,
                        backgroundColor: Colors.transparent,
                        backgroundImage: FileImage(
                          bloc.avatar!,
                        ),
                      ),
                    ]else...[
                      CircleAvatar(
                        radius: 55.w,
                        backgroundColor: Colors.transparent,
                        backgroundImage:  const AssetImage(
                          AppImages.nurseImg,
                        ),
                      ),
                    ],
                    const Icon(Icons.upload),
                  ],
                ),
              );
            },
          )
        ),
      ],
    );
  }
}