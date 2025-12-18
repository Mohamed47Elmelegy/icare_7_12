// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/home/presentation/widgets/background_with_raduis_home.dart';
import 'package:icare/features/home/presentation/widgets/publications/publications_list.dart';
import 'package:icare/features/home/presentation/widgets/specialists/view_all_specialists.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/notifications_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NotificationsUtils.pushNotificationListener(context);
    // Timer(const Duration(seconds: 2), () {
    //   if (mounted) CustomDialogs.patientGiveAccessToEditProfile(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onRefresh(context),
      color: DMUtil.getRED(),
      child: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeBackGroundWithRadius(
              setRequestBtn: true,
            ),

            PublicationsList(),
            // UserActivities(),
            SizedBox(
              height: 10,
            ),
            ViewAllSpecialists(),

            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Future onRefresh(BuildContext context) async {
    // await UserServiceRemoteDataSource.getAllServicesList();
    // NurseBloc.get(context).add(const FetchAllNurseEvent());
    // CategoriesBloc.get(context).add(const FetchAllPublicationsEvent());
  }
}
