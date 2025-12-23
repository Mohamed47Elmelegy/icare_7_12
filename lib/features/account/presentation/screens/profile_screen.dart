import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/screens/admin_profile.dart';
import 'package:icare/features/account/presentation/screens/nurse/nurse_profile.dart';
import 'package:icare/features/account/presentation/screens/patient_profile.dart';
import 'package:icare/features/account/presentation/screens/doctor/doctor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/widgets/account_before_auth.dart';
import 'package:icare/features/account/presentation/widgets/save_profile_btn.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Util.checkUser() ? const SaveProfileBtn() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
            color: DMUtil.getPC(),
            onRefresh: () => _buildRefresh(context),
            child: Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!Util.checkUser()) ...[
                      const AccountNotAuth(),
                    ] else ...[
                      if (Util.getUserType() ==
                          UserEnum.CUSTOMER.name.toString().toLowerCase()) ...[
                        const PatientProfile(),
                      ] else if (Util.getUserType() ==
                              UserEnum.NURSE.name.toString().toLowerCase() ||
                          Util.getUserType() ==
                              UserEnum.ASSISTANT.name
                                  .toString()
                                  .toLowerCase()) ...[
                        const NurseProfileScreen(),
                      ] else if (Util.getUserType() ==
                          UserEnum.DOCTOR.name.toString().toLowerCase()) ...[
                        const DoctorProfileScreen(),
                      ] else if (Util.getUserType() ==
                          UserEnum.ADMIN.name.toString().toLowerCase()) ...[
                        const AdminProfile(),
                      ],
                    ],
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            )));
  }

  Future<void> _buildRefresh(BuildContext context) async {
    AccountBloc.get(context)
      ..add(const FetchProfileDataEvent())
      ..add(const FetchAllNotificationsEvent())
      ..add(const FetchAllServicesEvent());
    // Util.getAllUserAppData(context: context);
  }
}
