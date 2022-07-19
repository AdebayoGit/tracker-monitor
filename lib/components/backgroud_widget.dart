import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({required this.image, required this.child, Key? key})
      : super(key: key);

  final String image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            image,
          ),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
        ),
      ),
      child: child,
    );
  }
}
