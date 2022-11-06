part of flutter_minigames;

class NumberTileWidget extends StatelessWidget {
  const NumberTileWidget({
    super.key,
    required this.width,
    required this.tile,
  });

  final NumberTile tile;

  final double width;

  Color color() {
    final number = tile.value;
    if (number <= 2) return const Color(0xFFF6E8DD);
    if (number <= 4) return const Color(0xFFF8E2CF);
    if (number <= 8) return const Color(0xFFFEB274);
    if (number <= 16) return const Color(0xFFF77F00);
    if (number <= 32) return const Color(0xFFFF7C59);
    if (number <= 64) return const Color(0xFFFE5D31);
    if (number <= 128) return const Color(0xFFFECD64);
    if (number <= 256) return const Color(0xFFEDCC62);
    if (number <= 512) return const Color(0xFFEDC850);
    if (number <= 1024) return const Color(0xFFEDC53F);
    if (number <= 2048) return const Color(0xFFEDC22E);

    if (number <= 4096) return const Color(0xFFF76574);
    if (number <= 8192) return const Color(0xFFEF4D61);
    if (number <= 16384) return const Color(0xFFE73B4C);
    if (number <= 32768) return const Color(0xFFE32739);
    if (number <= 65536) return const Color(0xFF5B95E5);
    if (number <= 131072) return const Color(0xFF5FA4E2);
    if (number <= 262144) return const Color(0xFF027DC0);

    return const Color(0xFF3C3A32);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: tile.stream,
      builder: (context, snapshot) {
        final posX = tile.x;
        final posY = tile.y;
        final number = tile.value;
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 256),
          curve: Curves.linearToEaseOut,
          left: posX * width / 4,
          top: posY * width / 4,
          child: AnimatedOpacity(
            opacity: tile.show ? 1 : 0,
            duration: const Duration(milliseconds: 256),
            child: SizedBox(
              width: width / 4,
              height: width / 4,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 256),
                    decoration: BoxDecoration(
                      color: color(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 64),
                        child: FittedBox(
                          key: ValueKey(number),
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              number.toString(),
                              style: TextStyle(
                                fontSize: 64,
                                color: number <= 4
                                    ? const Color(0xFF776E65)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
