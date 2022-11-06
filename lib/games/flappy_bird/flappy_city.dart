part of flutter_minigames;

class FlappyCityBackgroundImage extends StatelessWidget {
  const FlappyCityBackgroundImage({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/background-day.png',
      repeat: ImageRepeat.repeatX,
      scale: 0.5,
      height: height,
      width: width != null ? width! * 3 : null,
    );
  }
}
