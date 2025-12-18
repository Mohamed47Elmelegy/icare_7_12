import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/presentation/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainBookingScreen extends StatelessWidget {
  const MainBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (ctx, state) {
          // var user = AccountBloc.get(ctx).currentUser;
          // if(user==null)return const Center(child:  CircularProgressIndicator(color: Colors.black45,));
          return const OrderScreen();
        },
      ),
    );
  }
}
