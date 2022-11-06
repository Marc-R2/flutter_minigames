/* import 'dart:math';

import 'package:flutter/material.dart';

class RememberWallGame extends StatefulWidget {
  const RememberWallGame({super.key});

  @override
  State<RememberWallGame> createState() => _RememberWallGameState();
}

class _RememberWallGameState extends State<RememberWallGame> {
  final _red = GlobalData<bool>(key: 'rememberRed', value: false);
  final _blue = GlobalData<bool>(key: 'rememberBlue', value: false);
  final _yellow = GlobalData<bool>(key: 'rememberYellow', value: false);
  final _green = GlobalData<bool>(key: 'rememberGreen', value: false);

  final List<Corner> _corners = [];
  final List<Corner> _cornerInput = [];

  late final GlobalListener<bool> _redListen;

  late final GlobalListener<bool> _blueListen;

  late final GlobalListener<bool> _yellowListen;

  late final GlobalListener<bool> _greenListen;

  bool gameOver = false;
  bool gameReady = false;

  void _addCorner(Corner corner) {
    if (gameOver) return;
    print('pressed $corner');
    _cornerInput.add(corner);
    setState(() {});
    print('corners: $_corners / $_cornerInput');
    gameOver = !check();
    if (gameOver) {
      _gameOver();
    } else {
      if (_cornerInput.length == _corners.length) {
        _cornerInput.clear();
        addRandomCorner();
        playSequence();
      }
    }
  }

  @override
  void initState() {
    init();
    _redListen = _red.listen(
      (value) => (value && gameReady) ? _addCorner(Corner.topLeft) : null,
    );
    _blueListen = _blue.listen(
      (value) => (value && gameReady) ? _addCorner(Corner.bottomRight) : null,
    );
    _yellowListen = _yellow.listen(
      (value) => (value && gameReady) ? _addCorner(Corner.bottomLeft) : null,
    );
    _greenListen = _green.listen(
      (value) => (value && gameReady) ? _addCorner(Corner.topRight) : null,
    );
    super.initState();
  }

  Future<void> init() async {
    if (_corners.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 512));
    final corn = addRandomCorner();
    // set the corn color to true
    if (corn == Corner.topLeft) _red.value = true;
    if (corn == Corner.topRight) _green.value = true;
    if (corn == Corner.bottomLeft) _yellow.value = true;
    if (corn == Corner.bottomRight) _blue.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 32));
    gameReady = true;
  }

  Future<void> _gameOver() async {
    print('game over');
    gameReady = false;
    gameOver = true;
    await Future<void>.delayed(const Duration(milliseconds: 512));
    for (var i = 0; i < 3; i++) {
      _red.value = false;
      _green.value = false;
      _yellow.value = false;
      _blue.value = false;
      await Future<void>.delayed(const Duration(milliseconds: 512));
      _red.value = true;
      _green.value = true;
      _yellow.value = true;
      _blue.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 512));
    }
    if (mounted) {
      // beam to score page
      context.beamToNamed('/en/games/score/remember/$score');
    }
  }

  Corner addRandomCorner() {
    // Choose a random corner from enum
    final newCorner = Corner.values[Random().nextInt(Corner.values.length)];
    if (_corners.isNotEmpty && _corners.last == newCorner) {
      return addRandomCorner();
    }
    _corners.add(newCorner);
    return _corners.last;
  }

  bool check() {
    if (gameOver) return false;
    if (_corners.length < _cornerInput.length) {
      print('wrong length');
      return false;
    }
    for (var i = 0; i < _cornerInput.length; i++) {
      if (_corners[i] != _cornerInput[i]) {
        print('wrong corner');
        return false;
      }
    }
    print('correct');
    return true;
  }

  Future<void> playSequence() async {
    if (gameOver || !gameReady) return;
    gameReady = false;
    await Future<void>.delayed(const Duration(milliseconds: 1024));
    for (final corner in _corners) {
      if (corner == Corner.topLeft) _red.value = true;
      if (corner == Corner.topRight) _green.value = true;
      if (corner == Corner.bottomLeft) _yellow.value = true;
      if (corner == Corner.bottomRight) _blue.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 512));
      _red.value = false;
      _green.value = false;
      _yellow.value = false;
      _blue.value = false;
    }
    gameReady = true;
  }

  int get score => max(_corners.length, 1) - 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display score
          Text(
            'Score: $score',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            // White border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
              border: Border.all(color: Colors.white, width: 2),
            ),
            padding: const EdgeInsets.all(16),
            // 6 equal Slices in the circle in different colors
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RememberCorner(
                      color: Colors.red,
                      data: _red,
                      size: 200,
                      corner: Corner.topLeft,
                    ),
                    const SizedBox(width: 16),
                    RememberCorner(
                      color: Colors.green,
                      data: _green,
                      size: 200,
                      corner: Corner.topRight,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RememberCorner(
                        color: Colors.yellow,
                        data: _yellow,
                        size: 200,
                        corner: Corner.bottomLeft,
                      ),
                      const SizedBox(width: 16),
                      RememberCorner(
                        color: Colors.blue,
                        data: _blue,
                        size: 200,
                        corner: Corner.bottomRight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }

class RememberCorner extends StatelessWidget {
  const RememberCorner({
    super.key,
    required this.color,
    required this.corner,
    required this.data,
    required this.size,
  });

  final double size;
  final Color color;
  final Corner corner;
  final GlobalData<bool> data;

  BorderRadius getBorder() {
    final mainCorner = Radius.circular(size);
    const secondaryCorner = Radius.circular(32);
    const otherCorner = Radius.circular(8);

    final topLeft = corner == Corner.topLeft
        ? mainCorner
        : corner == Corner.bottomRight
            ? secondaryCorner
            : otherCorner;

    final topRight = corner == Corner.topRight
        ? mainCorner
        : corner == Corner.bottomLeft
            ? secondaryCorner
            : otherCorner;

    final bottomLeft = corner == Corner.bottomLeft
        ? mainCorner
        : corner == Corner.topRight
            ? secondaryCorner
            : otherCorner;

    final bottomRight = corner == Corner.bottomRight
        ? mainCorner
        : corner == Corner.topLeft
            ? secondaryCorner
            : otherCorner;

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  Future<void> onTap() async {
    print('tapped $corner');
    await Future<void>.delayed(const Duration(milliseconds: 64));
    data.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 256));
    data.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = getBorder();

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: color.withOpacity(0.25),
        child: DataBuilder(
            data: data,
            builder: (context, data) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 128),
                color: data ? color : Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashColor: color,
                  child: SizedBox(width: size, height: size),
                ),
              );
            }),
      ),
    );
  }
}
*/
