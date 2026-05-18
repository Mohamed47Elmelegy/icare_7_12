import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';
import 'package:icare/features/account/presentation/widgets/doctor_widgets/specialty_list_drop_down.dart';
import 'package:icare/features/account/presentation/widgets/doctor_widgets/specialty_row.dart';

/// Doctor-specific screen for specialty selection (single selection)
class DoctorProfileSpecialtiesTapScreen extends StatelessWidget {
  const DoctorProfileSpecialtiesTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var accountBloc = AccountBloc.get(ctx);
        var selectedSpecialty = accountBloc.selectedSpecialty;

        return BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, servicesState) {
            var servicesBloc = ServicesBloc.get(context);

            String displayTitle = selectedSpecialty?.title ?? '';

            // Resolve title from ServicesBloc if empty in AccountBloc
            if (displayTitle.isEmpty &&
                selectedSpecialty != null &&
                servicesBloc.allSpecialtiesList.isNotEmpty) {
              final match = servicesBloc.allSpecialtiesList.firstWhere(
                (element) => element.id == selectedSpecialty.id,
                orElse: () => servicesBloc.allSpecialtiesList.first,
              );
              displayTitle = match.title;
              // Optimistically update AccountBloc's reference too to prevent repeated lookups
              accountBloc.selectedSpecialty =
                  accountBloc.selectedSpecialty?.copyWith(title: displayTitle);
            }

            return Column(
              children: [
                // Dropdown to select specialty (only when editing)
                if (accountBloc.enableUpdate) ...[
                  const SpecialtyListDropDown(
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                ],

                // Show selected specialty
                if (selectedSpecialty != null) ...[
                  SpecialtyRow(
                    specialtyID: selectedSpecialty.id,
                    specialtyName: displayTitle,
                    isSelected: true,
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
