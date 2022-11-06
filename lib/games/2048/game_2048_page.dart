part of flutter_minigames;

class Play2048Game extends StatefulWidget {
  const Play2048Game({super.key, required this.onGameOver});

  final void Function(int score) onGameOver;

  @override
  State<Play2048Game> createState() => _Play2048GameState();
}

class _Play2048GameState extends State<Play2048Game> {
  bool _inProgress = false;
  bool _gameOver = false;

  void _update(SwipeDirection direction) {
    if (_inProgress || _gameOver) return;

    _process();

    switch (direction) {
      case SwipeDirection.up:
        _swipeUp();
        break;
      case SwipeDirection.down:
        _swipeDown();
        break;
      case SwipeDirection.left:
        _swipeLeft();
        break;
      case SwipeDirection.right:
        _swipeRight();
        break;
    }

    if (isGameOver()) _onGameOver();
  }

  Future<void> _onGameOver() async {
    _gameOver = true;
    setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 1024));
    for (final tile in tiles) {
      await Future<void>.delayed(const Duration(milliseconds: 128));
      tile
        ..show = false
        ..update();
    }
    await Future<void>.delayed(const Duration(milliseconds: 1024));

    // if (mounted) context.beamToNamed('/en/games/score/2048/$score');
    widget.onGameOver(score);
  }

  void _process() {
    if (_inProgress) return;
    _inProgress = true;
    Future.delayed(
      const Duration(milliseconds: 512),
      () => _inProgress = false,
    );
  }

  void _swipeLeft() {
    print('swipe left');
    var any = false;
    for (var y = 0; y < 4; y++) {
      final row = getRow(y);
      any = fuseTiles(row, (tile, x) {
            final change = x != tile.x;
            tile.x = x;
            return change;
          }) ||
          any;
    }

    if (any) _placeRandomTile();
  }

  void _swipeRight() {
    print('swipe right');
    var any = false;
    for (var y = 0; y < 4; y++) {
      final row = getRow(y).reversed.toList();
      any = fuseTiles(row, (tile, x) {
            final change = x - 3 != tile.x;
            tile.x = 3 - x;
            return change;
          }) ||
          any;
    }

    if (any) _placeRandomTile();
  }

  void _swipeUp() {
    print('swipe up');
    var any = false;
    for (var x = 0; x < 4; x++) {
      final column = getColumn(x);
      any = fuseTiles(column, (tile, y) {
            final change = y != tile.y;
            tile.y = y;
            return change;
          }) ||
          any;
    }

    if (any) _placeRandomTile();
  }

  void _swipeDown() {
    print('swipe down');
    var any = false;
    for (var x = 0; x < 4; x++) {
      final column = getColumn(x).reversed.toList();
      any = fuseTiles(column, (tile, y) {
            final change = y - 3 != tile.y;
            tile.y = 3 - y;
            return change;
          }) ||
          any;
    }

    if (any) _placeRandomTile();
  }

  // check if any tiles can be fused
  bool canFuseTiles() {
    for (var i = 0; i < tiles.length - 1; i++) {
      for (var j = i + 1; j < tiles.length; j++) {
        if (i == j) continue;
        final tile1 = tiles[i];
        final tile2 = tiles[j];

        // if tile1 is one left of tile2, and tile1 and tile2 are the same, they can be fused
        if (tile1.value != tile2.value) continue;
        if (tile1.x - 1 == tile2.x && tile1.y == tile2.y) return true;
        if (tile1.x == tile2.x - 1 && tile1.y == tile2.y) return true;
        if (tile1.x == tile2.x && tile1.y - 1 == tile2.y) return true;
        if (tile1.x == tile2.x && tile1.y == tile2.y - 1) return true;
      }
    }
    return false;
  }

  bool isGameOver() => tiles.length >= 16 && !canFuseTiles();

  List<NumberTile> tiles = [];

  int get score => tiles.fold(0, (sum, tile) => sum + tile.value);

  @override
  void initState() {
    // place two random tiles
    _placeRandomTile();
    _placeRandomTile();
    super.initState();
  }

  bool _placeRandomTile() {
    if (tiles.length >= 16) return false;
    final random = Random();
    final x = random.nextInt(4);
    final y = random.nextInt(4);
    if (!_checkPosition(x, y)) return _placeRandomTile();
    final value = random.nextInt(2) == 0 ? 2 : 4;
    final tile = NumberTile(x: x, y: y, value: value);
    tiles.add(tile);

    Future.delayed(
      const Duration(milliseconds: 512),
      () => tile
        ..show = true
        ..update(),
    );

    return true;
  }

  bool _checkPosition(int x, int y) => _getTile(x, y) == null;

  NumberTile? _getTile(int x, int y) {
    for (final tile in tiles) {
      if (tile.x == x && tile.y == y) return tile;
    }
    return null;
  }

  List<NumberTile> getRow(int y) {
    final row = <NumberTile>[];
    for (var x = 0; x < 4; x++) {
      final tile = _getTile(x, y);
      if (tile != null) row.add(tile);
    }
    return row;
  }

  List<NumberTile> getColumn(int x) {
    final column = <NumberTile>[];
    for (var y = 0; y < 4; y++) {
      final tile = _getTile(x, y);
      if (tile != null) column.add(tile);
    }
    return column;
  }

  bool fuseTiles(
    List<NumberTile> tiles,
    bool Function(NumberTile, int) onFused,
  ) {
    var any = false;
    tiles = tiles.reversed.toList();
    for (var i = 0; i < tiles.length - 1; i++) {
      final tile = tiles[i];
      final nextTile = tiles[i + 1];
      if (tile.value == nextTile.value) {
        tile..value *= 2..show = false;
        nextTile..value *= 2;
        any = true;
      }
    }

    var i = 0;
    tiles = tiles.reversed.toList();
    for (final tile in tiles) {
      any = onFused(tile, i) || any;
      if (tile.show) i++;
      if (!tile.show) tile.x += 1;
      tile.update();
    }

    this.tiles.removeWhere((element) => !element.show);

    if (mounted) setState(() {});

    return any;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: LayoutBuilder(builder: (context, cons) {
                final size = min(cons.maxWidth, cons.maxHeight) - 2;
                return GameSwipeDetector(
                  onSwipe: _update,
                  child: Container(
                    width: size + 2,
                    height: size + 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1024),
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _gameOver
                                ? Colors.black.withOpacity(0.5)
                                : Colors.transparent,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _gameOver ? 1 : 0,
                          duration: const Duration(milliseconds: 1024),
                          child: const Center(
                            child: Text(
                              'Game Over',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ...tiles.map(
                          (tile) => NumberTileWidget(
                            key: ValueKey(tile),
                            width: size,
                            tile: tile,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Text(
          'Score: $score',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
