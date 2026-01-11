import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/doctor_widgets/specialty_list_drop_down.dart';
import 'package:icare/features/account/presentation/widgets/doctor_widgets/specialty_row.dart';

/// Doctor-specific screen for specialty selection (single selection)
class DoctorProfileSpecialtiesTapScreen extends StatelessWidget {
  const DoctorProfileSpecialtiesTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        var selectedSpecialty = bloc.selectedSpecialty;

        return Column(
          children: [
            // Dropdown to select specialty (only when editing)
            if (bloc.enableUpdate) ...[
              const SpecialtyListDropDown(
                width: double.infinity,
              ),
              const SizedBox(height: 20),
            ],

            // Show selected specialty
            if (selectedSpecialty != null) ...[
              SpecialtyRow(
                specialtyID: selectedSpecialty.id,
                specialtyName: selectedSpecialty.title,
                isSelected: true,
              ),
            ],
          ],
        );
      },
    );
  }
}
