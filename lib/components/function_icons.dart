import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatefulWidget {
  final String iconSrc;
  final VoidCallback press;
  const CustomAnimatedIcon({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  State<CustomAnimatedIcon> createState() => _CustomAnimatedIconState();
}

class _CustomAnimatedIconState extends State<CustomAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;
  Color accentColor = Colors.greenAccent;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: 30,
        splashColor: accentColor,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          //size: Size(20, 20),
        ),
        onPressed: () => _handleOnPressed(),
      ),
    );
  }

  void _handleOnPressed() {
    widget.press;
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }
}
