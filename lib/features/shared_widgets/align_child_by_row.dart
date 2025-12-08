import 'package:flutter/cupertino.dart';

class AlignChildRow extends StatelessWidget {
  final Widget child;
  final bool isStart ;
  const AlignChildRow({super.key,required this.child,this.isStart =true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isStart?MainAxisAlignment.start:MainAxisAlignment.end,
      children: [child],
    );
  }
}
