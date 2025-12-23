import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/widgets/booking_taps_row.dart';
import 'package:icare/features/home/presentation/widgets/background_with_raduis_home.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/booking/presentation/widgets/small_order_widgets.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    NotificationsUtils.pushNotificationListener();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        body: RefreshIndicator(
          color: DMUtil.getPC(),
          onRefresh: () => _buildRefresh(context),
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                HomeBackGroundWithRadius(
                  enableBackIcon: false,
                ),
                SizedBox(
                  height: 20,
                ),
                BookingTapsRow(),
                OrderList(),
              ],
            ),
          ),
        ));
  }

  Future<void> _buildRefresh(BuildContext context) async {
    BookingBloc.get(context).add(const FetchAllOrderEvent());
  }
}
