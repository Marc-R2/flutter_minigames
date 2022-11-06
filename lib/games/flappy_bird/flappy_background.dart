part of flutter_minigames;

class FlappyBackground extends StatelessWidget {
  const FlappyBackground({
    required this.city,
    required this.floor,
    required this.upperTubeKey,
    required this.lowerTubeKey,
    super.key,
  });

  final double city;
  final double floor;
  final Key upperTubeKey;
  final Key lowerTubeKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            right: city % constraints.maxWidth - constraints.maxWidth,
            top: 0,
            child: FlappyCityBackgroundImage(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
          Positioned(
            right: floor % constraints.maxWidth - constraints.maxWidth,
            top: constraints.maxHeight / 2,
            child: FlappyFloorBackgroundImage(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
          // Main
          TubeAt(
            floor: floor,
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            upperTubeKey: upperTubeKey,
            lowerTubeKey: lowerTubeKey,
          ),
          ...List.generate(
            constraints.maxWidth ~/ 256,
            (index) {
              return TubeAt(
                floor: floor,
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                offset: index * 256,
              );
            },
          ),
          ...List.generate(
            constraints.maxWidth ~/ 256,
            (index) {
              return TubeAt(
                floor: floor,
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                offset: index * -256,
              );
            },
          ),
        ],
      );
    });
  }
}

class TubeAt extends StatelessWidget {
  const TubeAt({
    super.key,
    required this.floor,
    required this.height,
    required this.width,
    this.offset = 0,
    this.tubeDistance = 256,
    this.upperTubeKey,
    this.lowerTubeKey,
  });

  final double floor;
  final double height;
  final double width;
  final double offset;
  final double tubeDistance;

  final Key? upperTubeKey;
  final Key? lowerTubeKey;

  @override
  Widget build(BuildContext context) {
    final right =
        (width / 2) + (floor % tubeDistance) + offset - tubeDistance / 2 - 100;
    // Generate a random but consistent height for the tube
    final random = Random((floor - right).toInt());
    final tubeHeight = random.nextDouble() * height / 4 + height / 2;
    return Stack(
      children: [
        Positioned(
          top: tubeHeight,
          right: right,
          child: SizedBox(key: upperTubeKey, child: const FlappyTube()),
        ),
        Positioned(
          bottom: height - tubeHeight + 256,
          right: right,
          child: SizedBox(
            key: lowerTubeKey,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(pi),
              child: const FlappyTube(),
            ),
          ),
        )
      ],
    );
  }
}
