part of flutter_minigames;

class NumberTile {
  NumberTile({
    required this.x,
    required this.y,
    required this.value,
    this.show = false,
  });

  int x;
  int y;
  int value;
  bool show;

  // stream
  final StreamController<NumberTile> _controller =
      StreamController<NumberTile>.broadcast();

  Stream<NumberTile> get stream => _controller.stream;

  void update() => _controller.add(this);

  @override
  String toString() {
    return 'NumberTile{x: $x, y: $y, value: $value, show: $show}';
  }
}
