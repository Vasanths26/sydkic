import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGradientScreen extends StatefulWidget {
  const AnimatedGradientScreen({super.key});

  @override
  State<AnimatedGradientScreen> createState() => _AnimatedGradientScreenState();
}

class _AnimatedGradientScreenState extends State<AnimatedGradientScreen> {
  List<List<Color>> colorLists = [
    [const Color(0xff99FFFF), const Color(0xffFFFFFF)],
    [const Color(0xffFFFFFF), const Color(0xff99FFFF)],
  ];
  int index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        index = (index + 1) % colorLists.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: colorLists[index],
        ),
      ),
    );
  }
}
