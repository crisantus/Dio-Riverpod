
import 'package:flutter/material.dart';
import '../../../theme/pallete.dart';

class DioBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String btnName;
  const DioBtn({Key? key, required this.onTap, required this.btnName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      height: 50,
      minWidth: double.infinity,
      onPressed: onTap,
      color: Pallete.blueColor,
      textColor: Pallete.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child:  Text(btnName),
    );
  }
}