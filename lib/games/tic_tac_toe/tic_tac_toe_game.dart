part of flutter_minigames;

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 256), _init);
    super.initState();
  }

  bool showGrid = false;

  TTT nextToken = TTT.X;

  void _init() => setState(() => showGrid = true);

  final grid = <String, TTT>{};

  bool gameOver = false;

  void setToken(int i, int j) {
    if (grid['$i/$j'] != null) return;
    setState(() => grid['$i/$j'] = nextToken);
    nextToken = nextToken == TTT.X ? TTT.O : TTT.X;
    checkGrid();
  }

  void resetGrid() {
    setState(() {
      grid.clear();
      gameOver = false;
    });
  }

  bool checkColumn(int i) {
    final token = grid['$i/0'];
    if (token == null) return false;
    for (var j = 1; j < 3; j++) {
      if (grid['$i/$j'] != token) return false;
    }
    return true;
  }

  bool checkRow(int j) {
    final token = grid['0/$j'];
    if (token == null) return false;
    for (var i = 1; i < 3; i++) {
      if (grid['$i/$j'] != token) return false;
    }
    return true;
  }

  bool checkDiagonal() {
    final token = grid['0/0'];
    if (token == null) return false;
    for (var i = 1; i < 3; i++) {
      if (grid['$i/$i'] != token) return false;
    }
    return true;
  }

  bool checkAntiDiagonal() {
    final token = grid['0/2'];
    if (token == null) return false;
    for (var i = 1; i < 3; i++) {
      if (grid['$i/${2 - i}'] != token) return false;
    }
    return true;
  }

  void checkGrid() {
    for (var i = 0; i < 3; i++) {
      if (checkRow(i) || checkColumn(i)) {
        setState(() => gameOver = true);
        return;
      }
    }
    if (checkDiagonal() || checkAntiDiagonal() || grid.length == 9) {
      setState(() => gameOver = true);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 96,
            bottom: 32,
            left: 32,
            right: 32,
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 512),
            opacity: !gameOver ? 1 : 0.75,
            child: IgnorePointer(
              ignoring: gameOver,
              child: LayoutBuilder(
                builder: (context, cons) {
                  final size = min(cons.maxWidth, cons.maxHeight);
                  final cellSize = size / 3;
                  final width = cons.maxWidth;
                  final height = cons.maxHeight;
                  final dia = sqrt(size * size + size * size);
                  return Stack(
                    children: [
                      // Draw a Centered TicTacToe board
                      // Draw Fields
                      for (var i = 0; i < 3; i++)
                        for (var j = 0; j < 3; j++)
                          Positioned(
                            left: (width - size) / 2 + i * cellSize + 4,
                            top: (height - size) / 2 + j * cellSize + 4,
                            width: cellSize,
                            height: cellSize,
                            child: InkWell(
                              onTap: () => setToken(i, j),
                              child: SizedBox(
                                width: cellSize,
                                height: cellSize,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 256),
                                  child: grid['$i/$j'] == null
                                      ? null
                                      : grid['$i/$j'] == TTT.X
                                          ? TicTacToeX(size: cellSize)
                                          : TicTacToeO(size: cellSize),
                                ),
                              ),
                            ),
                          ),

                      // Vertical Lines
                      for (var i = 1; i < 3; i++)
                        Positioned(
                          left: cellSize * i + (width - size) / 2,
                          top: (height - size) / 2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 512),
                            curve: Curves.easeInOut,
                            width: 8,
                            height: showGrid ? size : 0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      // Horizontal Lines
                      for (var i = 1; i < 3; i++)
                        Positioned(
                          left: (width - size) / 2,
                          top: cellSize * i + (height - size) / 2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 512),
                            curve: Curves.easeInOut,
                            width: showGrid ? size : 0,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                      // Draw line where the player won
                      // Vertical Lines
                      for (var i = 0; i < 3; i++)
                        Positioned(
                          left: (cellSize * i + (width - size) / 2) +
                              cellSize / 2,
                          top: (height - size) / 2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 512),
                            curve: Curves.easeInOut,
                            width: 8,
                            height: (showGrid && checkColumn(i)) ? size : 0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                      // Horizontal Lines
                      for (var i = 0; i < 3; i++)
                        Positioned(
                          left: (width - size) / 2,
                          top: (cellSize * i + (height - size) / 2) +
                              cellSize / 2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 512),
                            curve: Curves.easeInOut,
                            width: (showGrid && checkRow(i)) ? size : 0,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                      // Diagonal Line / Rotated Container
                      // Based on cellSize
                      Positioned(
                        left: (width - size) / 2 + 16,
                        top: (height - size) / 2 + 8,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 512),
                          curve: Curves.easeInOut,
                          width: (showGrid && checkDiagonal()) ? dia - 32 : 0,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          transform: Matrix4.rotationZ(pi / 4),
                        ),
                      ),

                      // Anti Diagonal Line / Rotated Container
                      // Based on cellSize
                      Positioned(
                        left: (width - size) / 2 + 10,
                        top: (height - size) / 2 - 8 + size,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 512),
                          curve: Curves.easeInOut,
                          width:
                              (showGrid && checkAntiDiagonal()) ? dia - 32 : 0,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          transform: Matrix4.rotationZ(-pi / 4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        /* FloatingButton(
          width: 96,
          height: 96,
          posX: 0.1,
          posY: 0.3,
          tolerance: 0.075,
          onTap: () => setState(
            () => nextToken = nextToken == TTT.X ? TTT.O : TTT.X,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 64,
              height: 64,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 256),
                child: nextToken == TTT.X
                    ? const TicTacToeX(size: 64)
                    : const TicTacToeO(size: 64, padding: 16),
              ),
            ),
          ),
        ),
        FloatingButton(
          width: 96,
          height: 96,
          posX: 0.9,
          posY: 0.3,
          tolerance: 0.075,
          onTap: resetGrid,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Icon(Icons.refresh, size: 64, color: Colors.white),
            ),
          ),
        ),*/
      ],
    );
  }
}

class TicTacToeX extends StatelessWidget {
  const TicTacToeX({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: size / 2 - 4,
            top: 0,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 8,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            left: size / 2 - 4,
            top: 0,
            child: Transform.rotate(
              angle: -pi / 4,
              child: Container(
                width: 8,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicTacToeO extends StatelessWidget {
  const TicTacToeO({super.key, required this.size, this.padding = 48});

  final double size;

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size - padding,
        height: size - padding,
        // Draw a Circle with a white border 8px
        child: const CircularProgressIndicator(
          strokeWidth: 8,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          value: 1,
        ),
      ),
    );
  }
}

enum TTT { X, O, empty }
