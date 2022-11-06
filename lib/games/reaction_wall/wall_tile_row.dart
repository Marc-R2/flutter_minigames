part of flutter_minigames;

class WallTileRow extends StatelessWidget {
  const WallTileRow({
    super.key,
    required this.controllers,
    required this.posY,
    required this.size,
  });

  final int posY;
  final double size;

  final List<ReactiveTileController> controllers;

  @override
  Widget build(BuildContext context) {
    // print('build row: $posY => ${controllers.length}');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: controllers
          .asMap()
          .map(
            (i, controller) => MapEntry(
              i,
              Tile(controller: controller, posX: i, posY: posY, size: size),
            ),
          )
          .values
          .toList(),
    );
  }
}
