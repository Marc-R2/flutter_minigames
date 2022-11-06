part of flutter_minigames;

class ReactionWallTile extends StatefulWidget {
  const ReactionWallTile({
    required this.posX,
    required this.posY,
    this.size,
    this.color = Colors.grey,
    this.onTap,
    this.colorSwitchDuration = const Duration(milliseconds: 256),
    this.colorHoldDuration = const Duration(milliseconds: 128),
    super.key,
  });

  final int posX;
  final int posY;

  final double? size;

  final Duration colorSwitchDuration;
  final Duration colorHoldDuration;

  final Color color;
  final Color? Function(int posX, int posY, Color? color)? onTap;

  @override
  State<ReactionWallTile> createState() => _ReactionWallTileState();
}

class _ReactionWallTileState extends State<ReactionWallTile> {
  late Color color;

  @override
  void initState() {
    color = widget.color;
    super.initState();
  }

  Future<void> tap() async {
    if (widget.onTap == null) return;
    color = widget.onTap!(widget.posX, widget.posY, widget.color) ?? color;
    if (mounted) setState(() {});
    await Future.delayed(widget.colorHoldDuration);
    color = widget.color;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      // onHover: (val) => tap(),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedContainer(
          duration: widget.colorSwitchDuration,
          color: color,
          child: Image.asset('assets/games/wall/wall.png'),
        ),
      ),
    );
  }
}
