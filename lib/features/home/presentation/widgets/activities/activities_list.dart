import 'package:flutter/material.dart';
import 'package:icare/features/home/presentation/widgets/activities/activity_card.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return const ActivityCard();
      },
      separatorBuilder: (ctx, index) => const SizedBox(
        height: 15,
      ),
      itemCount: 3,
    );
  }
}
