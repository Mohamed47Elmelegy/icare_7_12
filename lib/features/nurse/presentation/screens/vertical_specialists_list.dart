import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart'
    as doctor_event;
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart'
    as doctor_bloc;
import 'package:icare/features/doctor/presentation/widgets/specialists_list.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart'
    as nurse_event;
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/specialists_list.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class AllSpecialistsScreen extends StatefulWidget {
  const AllSpecialistsScreen({super.key});
  static final TextEditingController searchTextEditingController =
      TextEditingController();

  @override
  State<AllSpecialistsScreen> createState() => _AllSpecialistsScreenState();
}

class _AllSpecialistsScreenState extends State<AllSpecialistsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    
    // Load initial data for both tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NurseBloc.get(context).add(const nurse_event.FetchAllNurseEvent());
      context.read<doctor_bloc.DoctorBloc>()
          .add(doctor_event.FetchAllDoctorEvent(page: 1));
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Trigger search for the new tab with current text
      var txt = AllSpecialistsScreen.searchTextEditingController.text.trim();
      if (_tabController.index == 0) {
        NurseBloc.get(context).add(nurse_event.UpdateSearchTxtEvent(txt: txt));
      } else {
        context.read<doctor_bloc.DoctorBloc>()
            .add(doctor_event.UpdateSearchTxtEvent(txt: txt));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GlobalAppBar(
          backGroundColor: DMUtil.getPC(),
          title: translate("icare.visit_specialists"),
          textColor: DMUtil.getWC(),
          whiteLogo: true,
          leadingIcon: BackArrowButton(
            color: DMUtil.getWC(),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: DMUtil.getPC(),
                unselectedLabelColor: Colors.grey,
                indicatorColor: DMUtil.getPC(),
                tabs: [
                  Tab(text: translate("nurse.nurse")),
                  Tab(text: translate("doctor.doctor")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabBody(context,
                      child: const VerticalSpecialistsList(),
                      onRefresh: () async => NurseBloc.get(context)
                          .add(const nurse_event.FetchAllNurseEvent()),
                      onSearch: (val) => NurseBloc.get(context)
                          .add(nurse_event.UpdateSearchTxtEvent(txt: val))),
                  _buildTabBody(context,
                      child: const VerticalDoctorSpecialistsList(),
                      onRefresh: () async => context.read<doctor_bloc.DoctorBloc>()
                          .add(doctor_event.FetchAllDoctorEvent(page: 1)),
                      onSearch: (val) => context.read<doctor_bloc.DoctorBloc>()
                          .add(doctor_event.UpdateSearchTxtEvent(txt: val))),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildTabBody(BuildContext context,
      {required Widget child,
      required Future<void> Function() onRefresh,
      required Function(String) onSearch}) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        color: DMUtil.getPC(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            child,
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
                onChanged: (val) => onSearch(val.toString().trim()),
                onFieldSubmitted: (val) {},
                textEditingController:
                    AllSpecialistsScreen.searchTextEditingController,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                suffixIcon: Icon(
                  Icons.search,
                  color: DMUtil.getPC(),
                  size: 20.w,
                ),
                isLabelError: false,
              ),
            ),
          ],
        ));
  }
}
