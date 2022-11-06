part of flutter_minigames;

class FlappyBirdUpImage extends StatelessWidget {
  const FlappyBirdUpImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/yellowbird-upflap.png',
      repeat: ImageRepeat.repeatX,
      scale: 0.5,
    );
  }
}

class FlappyBirdMidImage extends StatelessWidget {
  const FlappyBirdMidImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/yellowbird-midflap.png',
      repeat: ImageRepeat.repeatX,
      scale: 0.5,
    );
  }
}

class FlappyBirdDownImage extends StatelessWidget {
  const FlappyBirdDownImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/yellowbird-downflap.png',
      repeat: ImageRepeat.repeatX,
      scale: 0.5,
    );
  }
}
