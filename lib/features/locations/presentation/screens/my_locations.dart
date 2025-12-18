import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/locations/presentation/widgets/add_new_location_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/locations/presentation/widgets/locations_list.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class MyLocationsScreen extends StatelessWidget {
  const MyLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        bottomNavigationBar: const AddNewLocationButton(),
        appBar: GlobalAppBar(
          title: translate("profile.addresses"),
          leadingIcon: const BackArrowButton(),
        ),
        body: const LocationsList());
  }
}
