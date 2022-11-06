part of flutter_minigames;

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.size,
    required this.posX,
    required this.posY,
    required this.controller,
  });

  final double size;

  final int posX;
  final int posY;

  final ReactiveTileController controller;

  @override
  Widget build(BuildContext context) {
    // print('build tile: $posX/$posY');
    return StreamBuilder<ReactiveTile>(
      stream: controller.stream,
      builder: (context, snapshot) {
        // print('build tile: $posX/$posY => ${snapshot.data}');
        final data = snapshot.data;

        if (data == null) {
          return SizedBox(
            key: ValueKey('$posX/$posY Tile->SizedBox (Empty)'),
            width: size,
            height: size,
          );
        }

        return SizedBox(
          key: ValueKey('$posX/$posY Tile->SizedBox'),
          width: size,
          height: size,
          child: ColoredBox(
            color: Colors.white,
            child: AnimatedContainer(
              duration: data.colorSwitchDuration,
              color: data.color,
              child: ReactionWallTile(
                color: Colors.transparent,
                posX: posX,
                posY: posY,
                size: size,
                onTap: data.onTap,
                colorHoldDuration: data.colorHoldDuration,
                colorSwitchDuration: data.colorSwitchDuration,
              ),
            ),
          ),
        );
      },
    );
  }
}
