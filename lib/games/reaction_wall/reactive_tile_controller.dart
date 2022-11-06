part of flutter_minigames;

class ReactiveTileController {
  ReactiveTileController(this.posX, this.posY, ReactiveTile tile) {
    print('create tile controller: $posX/$posY');
    last = tile;
  }

  late ReactiveTile last;

  final int posX;
  final int posY;

  final StreamController<ReactiveTile> _streamController =
  StreamController<ReactiveTile>.broadcast();

  Stream<ReactiveTile> get stream => _streamController.stream;

  void updateTile(ReactiveTile tile) {
    // print('update tile: $posX/$posY => $tile');
    _streamController.add(tile);
  }

  void dispose() => _streamController.close();
}
