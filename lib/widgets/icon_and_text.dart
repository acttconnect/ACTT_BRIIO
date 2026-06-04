import 'package:briio_application/widgets/small_text.dart';
import 'package:flutter/material.dart';

class IconAndTex extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color iconColor;

   const IconAndTex({
     super.key,
     required this.icon,
     required this.text,

     required this.iconColor
   });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,),
        SmallText(text: text,)
      ],
    );
  }
}
