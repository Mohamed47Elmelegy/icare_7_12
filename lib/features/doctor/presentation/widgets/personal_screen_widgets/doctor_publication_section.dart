import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';

class DoctorPublicationSection extends StatelessWidget {
  const DoctorPublicationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (ctx, state) {
        var bloc = DoctorBloc.get(ctx);
        var currentDoctor = bloc.currentDoctor;
        if (currentDoctor == null || currentDoctor.publicationsList == null) {
          return const SizedBox.shrink();
        }
        var list = currentDoctor.publicationsList;
        if (list!.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 3.h,
            mainAxisSpacing: 1.h,
            childAspectRatio: 8.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            return DotWithTitleView(
              title: item,
              titleWidth: 300,
            );
          },
        );
      },
    );
  }
}
