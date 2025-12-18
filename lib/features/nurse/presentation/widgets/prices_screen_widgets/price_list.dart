import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/prices_screen_widgets/service_price_row.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';

class PricesListWidget extends StatelessWidget {
  const PricesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        var currentNurse = bloc.currentNurse;
        if (currentNurse == null || currentNurse.servicesList == null) {
          return const SizedBox.shrink();
        }
        var list = currentNurse.servicesList;
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
              return ServicePriceRow(
                serviceID: mainList[ind].id,
                serviceName: mainList[ind].value.toString(),
                price: item.value.toString(),
              );
            },
            separatorBuilder: (ctx, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: list.length);
      },
    );
  }
}
