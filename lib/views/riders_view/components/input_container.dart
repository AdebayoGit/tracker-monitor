import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';


class InputFieldContainer extends StatelessWidget {
  final Widget child;
  const InputFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      child: child,
    );
  }
}
