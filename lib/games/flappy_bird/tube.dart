part of flutter_minigames;

class FlappyTube extends StatelessWidget {
  const FlappyTube({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/pipe-green.png',
      scale: 0.5,
      height: height,
      width: width,
    );
  }
}

