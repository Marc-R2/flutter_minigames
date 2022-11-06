part of flutter_minigames;

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({Key? key}) : super(key: key);

  @override
  State<SnakeGameWidget> createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  late SnakeGame snakeGame;

  late List<List<SnakeItem>> _board;

  @override
  void initState() {
    restart();
    super.initState();
  }

  void restart() {
    clock?.cancel();
    clock = null;

    print('restart');
    snakeGame = SnakeGame(
      renderer: render,
      boardWidth: 16,
      boardHeight: 16,
      initialSnakeX: 5,
      initialSnakeY: 5,
      initialSnakeDirection: SnakeDirection.right,
      initialSnakeSize: 3,
      maxTicksBeforeFood: 16,
      minTicksBeforeFood: 5,
    );
    _board = snakeGame.getBoardWithSnake();

    if (mounted) setState(() {});
  }

  Timer? clock;

  void render() => setState(() => _board = snakeGame.getBoardWithSnake());

  void update(Timer t) {
    if (snakeGame.completed) {
      clock?.cancel();
    } else {
      snakeGame.tick();
    }
  }

  void startTicker() {
    if (clock != null) return;
    clock = Timer.periodic(const Duration(milliseconds: 250), update);
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  Color getColor(SnakeItem item, {double? opacity}) {
    if (opacity != null && item != SnakeItem.empty) return getColor(item).withOpacity(opacity);
    switch (item) {
      case SnakeItem.empty:
        return Colors.transparent;
      case SnakeItem.body:
        return Colors.green;
      case SnakeItem.food:
        return Colors.red;
      case SnakeItem.head:
        return Colors.blue;
      case SnakeItem.tail:
        return Colors.purple;
    }
  }

  void _swipeUp() {
    startTicker();
    if (snakeGame.directionLastTick != SnakeDirection.down) {
      snakeGame.directionNextTick = SnakeDirection.up;
    }
  }

  void _swipeDown() {
    startTicker();
    if (snakeGame.directionLastTick != SnakeDirection.up) {
      snakeGame.directionNextTick = SnakeDirection.down;
    }
  }

  void _swipeLeft() {
    startTicker();
    if (snakeGame.directionLastTick != SnakeDirection.right) {
      snakeGame.directionNextTick = SnakeDirection.left;
    }
  }

  void _swipeRight() {
    startTicker();
    if (snakeGame.directionLastTick != SnakeDirection.left) {
      snakeGame.directionNextTick = SnakeDirection.right;
    }
  }

  @override
  Widget build(BuildContext context) {
    // draw the _board
    return FutureBuilder(
      future: snakeGame.gameFuture,
      builder: (context, snapshot) {
        final isEnd = snakeGame.completed;
        return Container(
          // white border
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, cons) {
              final size = min(cons.maxWidth, cons.maxHeight);
              final tileSize = size / _board.length;
              return GameSwipeDetector(
                onSwipeUp: _swipeUp,
                onSwipeDown: _swipeDown,
                onSwipeLeft: _swipeLeft,
                onSwipeRight: _swipeRight,
                child: Stack(
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 16,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 16 * 16,
                        itemBuilder: (context, index) {
                          final x = index % 16;
                          final y = index ~/ 16;
                          final item = _board[y][x];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: isEnd ? 512 : 64),
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: getColor(item, opacity: isEnd ? 0.5 : 1),
                              //.withOpacity(isEnd ? 1 : 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 2,
                                color: !isEnd
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white.withOpacity(0),
                              ),
                            ),
                            width: tileSize,
                            height: tileSize,
                          );
                        },
                      ),
                    ),
                    IgnorePointer(
                      ignoring: !isEnd,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 512),
                        opacity: snakeGame.completed ? 1 : 0,
                        child: SizedBox(
                          width: size,
                          height: size,
                          // color: Colors.black.withOpacity(0.25),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Game Over',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                IconButton(
                                  onPressed: restart,
                                  icon: const Icon(
                                    Icons.refresh,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
