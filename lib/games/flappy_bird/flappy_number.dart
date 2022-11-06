part of flutter_minigames;

class FlappyNumber extends StatelessWidget {
  const FlappyNumber({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final digit in number.toString().split('')) ...[
          Image.network(
            'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/$digit.png',
            scale: 0.5,
          ),
          const SizedBox(width: 4),
        ],
      ],
    );
  }
}

