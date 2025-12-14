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
        if (currentDoctor == null || currentDoctor.servicesList == null) return const SizedBox.shrink();
        var list = currentDoctor.servicesList;
        if (list!.isEmpty) return const EmptyDataWidget();
        return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            var item = list[index];
            var mainList = AccountBloc.get(context).allServiceList;
            int ind = mainList.indexWhere((element) => item.id == element.id);
            if (ind == -1) return const SizedBox.shrink();
            return DoctorServicePriceRow(
              serviceID: mainList[ind].id,
              serviceName: mainList[ind].value.toString(),
              price: item.value.toString(),
            );
          },
          separatorBuilder: (ctx, index) => const SizedBox(height: 10),
          itemCount: list.length,
        );
      },
    );
  }
}
