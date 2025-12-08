import 'package:flutter/material.dart';
import 'package:icare/features/home/presentation/widgets/main_slider.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return const Column(
      children: [
        SliderWidget(),


        SizedBox(height: 10,),


      ],
    );
  }
}
