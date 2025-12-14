import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/widgets/vertical_specialist_card.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalDoctorSpecialistsList extends StatelessWidget {
  const VerticalDoctorSpecialistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (ctx, state) {
        var bloc = ctx.read<DoctorBloc>();
        if (state is FetchAllDoctorsLoadingState) return const Center(child: CircularProgressIndicator(color: kPrimary));
        if (state is! FetchAllDoctorsLoadingState && bloc.doctorsList.isEmpty) return const EmptyDataWidget();
        var list = bloc.doctorsList;
        if (bloc.searchText != '') {
          list = bloc.doctorsList
              .where((v) => v.userData != null && v.userData!.userName.toString().toLowerCase().trim().startsWith(bloc.searchText.toLowerCase()))
              .toList();
        }
        return Scrollbar(
          child: ListView.separated(
            itemCount: list.length,
            padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w, vertical: 70.h),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var item = list[index];
              if (item.userData == null) return const SizedBox.shrink();
              return VerticalDoctorSpecialistCard(doctor: item);
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: list[index].userData == null ? 0 : 5.w),
          ),
        );
      },
    );
  }
}
