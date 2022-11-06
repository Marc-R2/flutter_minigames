part of flutter_minigames;

class FlappyFlyAnimation extends StatefulWidget {
  const FlappyFlyAnimation({super.key});

  @override
  State<FlappyFlyAnimation> createState() => _FlappyFlyAnimationState();
}

class _FlappyFlyAnimationState extends State<FlappyFlyAnimation> {
  int state = 0;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 96), _updateState);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _updateState(Timer t) {
    setState(() => state = (state + 1) % 3);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const FlappyBirdMidImage();
    if (state == 0) child = const FlappyBirdDownImage();
    if (state == 2) child = const FlappyBirdUpImage();
    // return ColoredBox(color: Colors.red, child: child);
    return child;
  }
}
