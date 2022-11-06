part of flutter_minigames;

class ReactionWall extends StatelessWidget {
  const ReactionWall({
    super.key,
    required this.tiles,
    required this.size,
  });

  final double size;
  final List<List<ReactiveTileController>> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tiles
          .asMap()
          .map((i, row) => MapEntry(
              i,
              WallTileRow(
                posY: i,
                controllers: row,
                size: size,
              )))
          .values
          .toList(),
    );
  }
}
