part of flutter_minigames;

class FlappyBirdGame extends StatefulWidget {
  const FlappyBirdGame({super.key, required this.onGameOver});

  final void Function(int score) onGameOver;

  @override
  State<FlappyBirdGame> createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends State<FlappyBirdGame> {
  bool inGame = false;
  bool gameOver = false;
  int score = 0;

  double birdY = 0.9;
  double birdR = 0.0;

  var _city = 0.0;
  var _floor = 0.0;

  late GlobalKey upperTubeKey;
  late GlobalKey lowerTubeKey;
  late GlobalKey birdKey;

  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 10), _update);
    upperTubeKey = GlobalKey();
    lowerTubeKey = GlobalKey();
    birdKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _update(Timer t) {
    if (inGame) {
      birdY += _rotateY(birdR);
      if (birdR < 80) birdR += _rotateR((birdR - 65) / 90);
      if (birdY > 1.75) {
        gameOver = true;
        birdY = 1.75;
        // context.beamToNamed('/en/games/score/flappy_bird/$score');
        widget.onGameOver(score);
      } else {
        _floor += 2;
        _city += 0.75;
      }

      final collision = birdCollidesWithTube();
      if (collision) gameOver = true;

      setState(() => score = (_floor / 256).floor());
    }
  }

  double _rotateY(double x) => min(x * x * x * 0.000000123456789, 0.02);

  double _rotateR(double x) => 0.75 + x * x;

  bool birdCollidesWithTube() {
    if (!mounted) return false;
    RenderBox box1 =
        upperTubeKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox box2 =
        lowerTubeKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox box3 = birdKey.currentContext?.findRenderObject() as RenderBox;

    var bird = box3.localToGlobal(Offset.zero);
    var upperTube = box1.localToGlobal(Offset.zero);
    var lowerTube = box2.localToGlobal(Offset.zero);

    var upperTubeSize = box1.size;
    var lowerTubeSize = box2.size;
    var birdSize = box3.size;

    const smallerBird = 32;

    var birdRect = Rect.fromLTWH(
      bird.dx + smallerBird / 2,
      bird.dy + smallerBird / 2,
      birdSize.width - smallerBird,
      birdSize.height - smallerBird,
    );

    var upperTubeRect = Rect.fromLTWH(
      upperTube.dx,
      upperTube.dy,
      upperTubeSize.width,
      upperTubeSize.height,
    );

    var lowerTubeRect = Rect.fromLTWH(
      lowerTube.dx,
      lowerTube.dy,
      lowerTubeSize.width,
      lowerTubeSize.height,
    );

    return birdRect.overlaps(lowerTubeRect) || birdRect.overlaps(upperTubeRect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              print('tap');
              if (inGame && !gameOver) {
                setState(() => birdR = -60);
              } else {
                setState(() => inGame = true);
              }
            },
            child: FlappyBackground(
              city: _city,
              floor: _floor,
              upperTubeKey: upperTubeKey,
              lowerTubeKey: lowerTubeKey,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment(0, birdY - 1),
              child: Transform.rotate(
                angle: birdR * pi / 180,
                child: FlappyFlyAnimation(key: birdKey),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.8),
            child: inGame ? FlappyNumber(number: score) : null,
          ),
          IgnorePointer(
            ignoring: true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 128),
              child: inGame ? null : const FlappyStart(),
            ),
          ),
        ],
      ),
    );
  }
}
