part of flutter_minigames;

class ReactionWallGame extends StatefulWidget {
  const ReactionWallGame({
    super.key,
    this.columns = 6,
    required this.onGameOver,
  });

  final int columns;

  final void Function(int score) onGameOver;

  @override
  State<ReactionWallGame> createState() => _ReactionWallGameState();
}

class _ReactionWallGameState extends State<ReactionWallGame> {
  final tiles = <String, ReactiveTileController>{};

  int? currentTile;

  DateTime? endTime;

  var _score = 0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () => setNextTap());
    super.initState();
  }

  void setNextTap() {
    if (_score == 0) endTime = DateTime.now().add(const Duration(seconds: 16));

    // Choose random tile from tiles
    final newTile = Random().nextInt(tiles.length);
    if (newTile == currentTile) return setNextTap();
    currentTile = newTile;

    final tile = tiles.values.toList()[newTile];

    tile.updateTile(
      ReactiveTile(
        color: Colors.yellow,
        colorSwitchDuration: const Duration(milliseconds: 128),
        colorHoldDuration: const Duration(milliseconds: 256),
        onTap: (x, y, c) {
          setNextTap();
          setState(() {
            endTime = endTime?.add(const Duration(milliseconds: 512));
            _score++;
          });
          return Colors.green;
        },
      ),
    );

    // Clear all other tiles
    for (var element in tiles.values) {
      if (element != tile) {
        element.updateTile(
          ReactiveTile(
            color: (endTime?.difference(DateTime.now()).inMilliseconds ?? 10) >
                    5000
                ? Colors.white.withOpacity(0.125)
                : Colors.orange.withOpacity(0.125),
            colorSwitchDuration: const Duration(milliseconds: 1024),
            colorHoldDuration: const Duration(milliseconds: 512),
            onTap: (x, y, c) {
              if (_score == 0) {
                // return random color
                return Color((Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0);
              }
              gameOver();
              setState(() => endTime = null);
              return Colors.red;
            },
          ),
        );
      }
    }
  }

  Future<void> gameOver() async {
    colorAllTiles(Colors.red);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.white);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.red);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.white);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.red);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.white);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.red);
    await Future.delayed(const Duration(milliseconds: 512));
    colorAllTiles(Colors.grey);
    await Future.delayed(const Duration(milliseconds: 1024));
    // if (mounted) context.beamToNamed('/en/games/score/wall/$_score');
    widget.onGameOver(_score);
  }

  void colorAllTiles(Color color) {
    for (var element in tiles.values) {
      element.updateTile(
        ReactiveTile(
          color: color,
          colorSwitchDuration: const Duration(milliseconds: 512),
          colorHoldDuration: const Duration(milliseconds: 512),
        ),
      );
    }
  }

  ReactiveTileController getTile(int x, int y) {
    final id = '$x/$y';
    if (tiles.containsKey(id)) return tiles[id]!;

    final ini = ReactiveTile(
      color: Colors.grey,
      colorSwitchDuration: const Duration(milliseconds: 128),
      colorHoldDuration: const Duration(milliseconds: 256),
      onTap: (x, y, c) => Colors.red,
    );

    final tile = ReactiveTileController(x, y, ini);

    Future.delayed(Duration(milliseconds: x * 128 + y * 64), () {
      tile.updateTile(ini);
    });

    tiles[id] = tile;
    return tile;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                _score == 0 ? 'Tap colored tile to start' : 'Score: $_score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TimerCountdown(endTime: endTime, onEnd: gameOver),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth / widget.columns;
                final rows = constraints.maxHeight ~/ size;
                return ReactionWall(
                  size: size,
                  tiles: List.generate(
                    rows,
                    (i1) => List.generate(widget.columns, (i2) {
                      final tile = getTile(i1, i2);
                      return tile;
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TimerCountdown extends StatefulWidget {
  const TimerCountdown({
    super.key,
    this.endTime,
    required this.onEnd,
  });

  final DateTime? endTime;

  final void Function() onEnd;

  @override
  State<TimerCountdown> createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 8), updateTimer);
    super.initState();
  }

  void updateTimer(Timer t) {
    if (widget.endTime == null) return;
    if (mounted) setState(() {});
    if (DateTime.now().isAfter(widget.endTime!)) {
      timer?.cancel();
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.endTime == null) return const SizedBox();
    final t = widget.endTime!.difference(DateTime.now()).inMilliseconds / 1000;
    final s = max(t, 0);
    final ms = (s * 1000).round() % 1000;
    final sec = s.round() % 60;
    return Text(
      '${sec.toString().padLeft(3, '0')}.${ms.toString().padRight(3, '0')}s',
      style: TextStyle(
        color: t > 10
            ? Colors.white
            : t > 5
                ? Colors.orange
                : Colors.red,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
