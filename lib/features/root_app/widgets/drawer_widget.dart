import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/root_app/widgets/main_drawer_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DMUtil.getWC(),
      width: 240.w,
      child: SingleChildScrollView(
        child: BlocBuilder<RootBloc,RootState>(
          builder: (ctx,state){
            return Column(
              children: [
                MainDrawerSection(ctx: context),
                // if(bloc.drawerEnum == DrawerEnum.OUR_COMPANY)...[
                //   OurCompanySection(ctx: context),
                // ]else if(bloc.drawerEnum == DrawerEnum.PRIVACY)...[
                //   OurPrivacySection(ctx: context),
                // ]else ...[
                //   MainDrawerSection(ctx: context),
                // ],
              ],
            );
          },
        )
      ),
    );
  }
}
