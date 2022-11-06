part of flutter_minigames;

class FlappyStart extends StatelessWidget {
  const FlappyStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(128),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Image.network(
              'https://raw.githubusercontent.com/samuelcust/flappy-bird-assets/master/sprites/message.png',
              fit: BoxFit.fitHeight,
              height: constraints.maxHeight,
            );
          },
        ),
      ),
    );
  }
}
