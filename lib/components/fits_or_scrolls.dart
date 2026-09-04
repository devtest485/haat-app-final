import 'package:flutter/material.dart';

/// Keeps a full-height layout exactly as designed when there is room, and scrolls it
/// when there is not.
///
/// ## The problem it solves
///
/// These screens are laid out as
/// `Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: spaceBetween)` — a title
/// block pinned to the top, a button pinned to the bottom, and the gap between them
/// taking whatever is left. That is the right structure, and it is what the designs
/// call for.
///
/// It only works while the content is shorter than the screen. The moment it is not —
/// a taller keypad, a longer sentence, a smaller handset, a larger system font — the
/// column has nowhere to put the excess and Flutter paints the yellow-and-black bar.
/// A user sees a button cut in half.
///
/// Wrapping the column in a plain `SingleChildScrollView` fixes the overflow and breaks
/// the design: the scroll view gives its child unbounded height, so `spaceBetween` has
/// nothing to distribute and everything bunches at the top with a gap underneath.
///
/// ## How this works
///
/// [LayoutBuilder] measures the space available, `ConstrainedBox` says "be at least
/// that tall", and [IntrinsicHeight] lets the column ask for more when its contents
/// need it. So:
///
/// - **Content fits** — the column is exactly viewport height and `spaceBetween`
///   spreads as designed. Nothing scrolls, and nothing looks different.
/// - **Content does not fit** — the column takes its natural height and the view
///   scrolls to reach the rest.
///
/// One behaviour, both cases, and no screen-size guessing.
///
/// ## What it costs
///
/// `IntrinsicHeight` measures its child twice, so this belongs around a screen's outer
/// column and not around a list. For anything that repeats or is long, a
/// `ListView`/`CustomScrollView` is the right tool.
class FitsOrScrolls extends StatelessWidget {
  const FitsOrScrolls({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.physics,
  });

  /// Usually a `Column(mainAxisSize: MainAxisSize.max)` with a `mainAxisAlignment`
  /// that needs a bounded height to mean anything.
  final Widget child;

  final EdgeInsetsGeometry padding;

  /// Left null so the platform default applies — bounce on iOS, glow on Android.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: padding,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // `maxHeight` is what the parent offered. Asking for at least that much
              // is what keeps spaceBetween meaningful on a screen with room to spare.
              minHeight: constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : 0.0,
            ),
            child: IntrinsicHeight(child: child),
          ),
        ),
      );
}
