part of flutter_minigames;

class GameSwipeDetector extends StatelessWidget {
  const GameSwipeDetector({
    super.key,
    this.onSwipe,
    this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.sensitivity = 0.5,
  });

  final void Function(SwipeDirection direction)? onSwipe;

  final void Function()? onSwipeUp;

  final void Function()? onSwipeDown;

  final void Function()? onSwipeLeft;

  final void Function()? onSwipeRight;

  final Widget? child;

  final double sensitivity;

  void _onPanUpdate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final dxAbs = dx.abs();
    final dy = details.delta.dy;
    final dyAbs = dy.abs();

    if (dxAbs > dyAbs) {
      if (dx > sensitivity) {
        onSwipe?.call(SwipeDirection.right);
        onSwipeRight?.call();
      } else if (dx < -sensitivity) {
        onSwipe?.call(SwipeDirection.left);
        onSwipeLeft?.call();
      }
    } else {
      if (dy > sensitivity) {
        onSwipe?.call(SwipeDirection.down);
        onSwipeDown?.call();
      } else if (dy < -sensitivity) {
        onSwipe?.call(SwipeDirection.up);
        onSwipeUp?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: child,
    );
  }
}

enum SwipeDirection { up, down, left, right }
