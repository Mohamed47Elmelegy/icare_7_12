import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/upload_document.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/edit_icon.dart';

class ProfileImageEdit extends StatelessWidget {
  final String img;
  final bool enableEditIcon;
  final bool enablePadding;
  final double iconSize;
  const ProfileImageEdit(
      {super.key,
      required this.enableEditIcon,
      required this.img,
      this.enablePadding = true,
      this.iconSize = 50});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        if (bloc.currentUser == null) {
          return CircleAvatar(
            radius: iconSize.w,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(
              img,
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: enablePadding ? 132.w : 0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              bloc.enableUpdateImg
                  ? Stack(
                      children: [
                        bloc.avatar == null
                            ? CircleAvatar(
                                radius: iconSize.w,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  img,
                                ),
                              )
                            : CircleAvatar(
                                radius: iconSize.w,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(bloc.avatar!),
                              ),
                      ],
                    )
                  : bloc.currentUser!.image == ""
                      ? CircleAvatar(
                          radius: iconSize.w,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            img,
                          ),
                        )
                      : CircleAvatar(
                          radius: iconSize.w,
                          backgroundColor: kPrimary,
                          backgroundImage:
                              NetworkImage(bloc.currentUser!.image.toString()),
                        ),
              if (enableEditIcon) ...[
                if (bloc.enableUpdateImg) ...[
                  InkWell(
                    onTap: () async {
                      final res = await getImage(ctx: context);
                      if (res == null) return;
                      final file = await cropImage(res);
                      if (file != null) {
                        bloc.add(UpdateProfileCurrentDataEvent(userData: {
                          'avatar': file,
                        }));
                      }
                    },
                    child: Icon(
                      Icons.upload,
                      color: DMUtil.getDC().withOpacity(0.6),
                      size: 17.w,
                    ),
                  ),
                ] else ...[
                  InkWell(
                    onTap: () => AccountBloc.get(context)
                        .add(const EnableUpdateProfileEvent(isImg: true)),
                    child: const EditIcon(),
                  )
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
