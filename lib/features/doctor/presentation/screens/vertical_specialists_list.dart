import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/widgets/specialists_list.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class AllDoctorSpecialistsScreen extends StatelessWidget {
  const AllDoctorSpecialistsScreen({super.key});
  static final TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getPC(),
        title: translate("icare.visit_specialists"),
        textColor: DMUtil.getWC(),
        whiteLogo: true,
        leadingIcon: BackArrowButton(color: DMUtil.getWC()),
      ),
      body: RefreshIndicator(
        onRefresh: () => _buildRefresh(context),
        color: DMUtil.getPC(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const VerticalDoctorSpecialistsList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFromField(
                hasBorder: true,
                borderWidth: 1,
                borderColor: DMUtil.getD2C(),
                labelText: '',
                height: 45,
                hintText: translate("app_bar.search"),
                radius: 10,
                onChanged: (val) => DoctorBloc.get(context).add(UpdateSearchTxtEvent(txt: val.toString().trim())),
                onFieldSubmitted: (val) {},
                textEditingController: searchTextEditingController,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                suffixIcon: Icon(Icons.search, color: DMUtil.getPC(), size: 20.w),
                isLabelError: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildRefresh(BuildContext context) async {
    DoctorBloc.get(context).add(const FetchAllDoctorEvent());
  }
}
