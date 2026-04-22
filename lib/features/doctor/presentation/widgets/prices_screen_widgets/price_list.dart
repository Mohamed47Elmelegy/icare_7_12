import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/widgets/prices_screen_widgets/service_price_row.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';

class DoctorPricesListWidget extends StatelessWidget {
  const DoctorPricesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (ctx, state) {
        var bloc = DoctorBloc.get(ctx);
        var currentDoctor = bloc.currentDoctor;

        if (currentDoctor == null) {
          return const SizedBox.shrink();
        }

        // For doctors, we display their specialty as the "service"
        // Since doctors have only one specialty, we show a single item list
        var specialtyId = currentDoctor.specialtyId;

        if (specialtyId == null) {
          return const EmptyDataWidget();
        }

        // Get specialty name from AccountBloc
        var accountBloc = AccountBloc.get(context);
        String specialtyName = "";

        try {
          var specialty = accountBloc.allSpecialtiesList.firstWhere(
            (element) => element.id.toString() == specialtyId,
            orElse: () => accountBloc.allSpecialtiesList.firstWhere(
              (element) => element.id == int.tryParse(specialtyId),
            ),
          );
          specialtyName = specialty.title;
        } catch (e) {
          // If not found in list, fallback or keep empty
        }

        return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return DoctorServicePriceRow(
              serviceID: int.tryParse(specialtyId) ?? 0,
              serviceName:
                  specialtyName.isNotEmpty ? specialtyName : "Doctor Visit",
              price:
                  "0", // Doctors usually don't have a fixed price in this app structure yet, or it's negotiated
            );
          },
          separatorBuilder: (ctx, index) => const SizedBox(height: 10),
          itemCount: 1, // Only 1 specialty
        );
      },
    );
  }
}
