part of flutter_minigames;

class ReactiveTile {
  const ReactiveTile({
    required this.color,
    required this.colorSwitchDuration,
    required this.colorHoldDuration,
    this.onTap,
  });

  final Duration colorSwitchDuration;
  final Duration colorHoldDuration;

  final Color color;
  final Color? Function(int posX, int posY, Color? color)? onTap;
}
