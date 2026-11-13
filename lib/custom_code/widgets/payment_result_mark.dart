// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:ui';

import 'package:lottie/lottie.dart';

/// Payment result mark: a frosted-glass disc with the result Lottie on top.
///
/// [status] is `success` (default), `failed` or `pending`. Success pops the
/// disc in (0 → 112% → 96% → 100%), failed pops it and shakes it, pending
/// loops the Lottie. Laid out on the comps' 200×168 canvas, scaled to fit.
class PaymentResultMark extends StatefulWidget {
  const PaymentResultMark({
    super.key,
    this.width,
    this.height,
    this.status,
  });

  final double? width;
  final double? height;
  final String? status;

  @override
  State<PaymentResultMark> createState() => _PaymentResultMarkState();
}

class _PaymentResultMarkState extends State<PaymentResultMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _disc = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  String get _status {
    final status = (widget.status ?? '').trim();
    return status == 'failed' || status == 'pending' ? status : 'success';
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant PaymentResultMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.status ?? '').trim() != (widget.status ?? '').trim()) {
      _start();
    }
  }

  void _start() {
    if (_status == 'pending') {
      _disc.value = 1;
    } else {
      _disc.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _disc.dispose();
    super.dispose();
  }

  // Disc scale over the 800 ms controller.
  static final _successScale = TweenSequence<double>([
    TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 200),
    TweenSequenceItem(
        tween: Tween(begin: 1.12, end: 0.96)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 133),
    TweenSequenceItem(
        tween: Tween(begin: 0.96, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 117),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 350),
  ]);

  static final _failedScale = TweenSequence<double>([
    TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 233),
    TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 184),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 383),
  ]);

  // Horizontal shake for failed: -6, +6, -4, +4, -2, 0 px from 500 ms.
  static final _failedShake = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 500),
    for (final (from, to) in const [
      (0.0, -6.0),
      (-6.0, 6.0),
      (6.0, -4.0),
      (-4.0, 4.0),
      (4.0, -2.0),
      (-2.0, 0.0),
    ])
      TweenSequenceItem(
          tween: Tween(begin: from, end: to)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50),
  ]);

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return SizedBox(
      width: widget.width ?? 200.0,
      height: widget.height ?? 168.0,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 200.0,
          height: 168.0,
          child: Stack(
            alignment: AlignmentDirectional(0.0, 0.0),
            children: [
              AnimatedBuilder(
                animation: _disc,
                builder: (context, child) {
                  final t = reduceMotion ? 1.0 : _disc.value;
                  final scale = switch (status) {
                    'success' => _successScale.transform(t),
                    'failed' => _failedScale.transform(t),
                    _ => 1.0,
                  };
                  final dx =
                      status == 'failed' ? _failedShake.transform(t) : 0.0;
                  return Transform.translate(
                    offset: Offset(dx, 0.0),
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      width: 96.0,
                      height: 96.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                    ),
                  ),
                ),
              ),
              Lottie.memory(
                _comps[status]!,
                width: 200.0,
                height: 168.0,
                fit: BoxFit.contain,
                repeat: status == 'pending',
                animate: !reduceMotion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The result comps (assets/jsons/result-*.json), embedded so FlutterFlow needs no
// uploaded asset. Kept as static bytes so Lottie's cache sees the same key.
final Map<String, Uint8List> _comps = {
  'success': utf8.encode(_successJson),
  'failed': utf8.encode(_failedJson),
  'pending': utf8.encode(_pendingJson),
};

const _successJson =
    r'''{"v":"5.7.4","fr":60,"ip":0,"op":60,"w":200,"h":168,"nm":"HAAT · Result · success (one shot)","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":2,"ty":4,"nm":"Check (icon.primary)","sr":1,"parent":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[0,0,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":1,"k":[{"t":0,"s":[100,100,100],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":27,"s":[100,100,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":33,"s":[118,118,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":42,"s":[100,100,100]}]}},"ao":0,"shapes":[{"ty":"gr","nm":"Check","it":[{"ty":"sh","nm":"Tick","ks":{"a":0,"k":{"i":[[0,0],[0,0],[0,0]],"o":[[0,0],[0,0],[0,0]],"v":[[-12.05,-0.82],[-3.92,7.31],[12.05,-8.65]],"c":false}}},{"ty":"tm","s":{"a":0,"k":0},"e":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":12,"s":[0],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":28,"s":[100]}]},"o":{"a":0,"k":0},"m":1},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":3.4},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":90,"st":0,"bm":0},{"ddd":0,"ind":1,"ty":4,"nm":"Status disc 72 (result.disc-bg)","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,100,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":1,"k":[{"t":0,"s":[0,0,100],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":12,"s":[112,112,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":20,"s":[96,96,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":27,"s":[100,100,100]}]}},"ao":0,"shapes":[{"ty":"gr","nm":"Disc","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[72,72]},"d":1},{"ty":"fl","c":{"a":0,"k":[1,1,1,1]},"o":{"a":0,"k":30},"r":1},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":90,"st":0,"bm":0,"parent":10},{"ddd":0,"ind":3,"ty":4,"nm":"Halo (white)","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,100,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},"ao":0,"shapes":[{"ty":"gr","nm":"Halo","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":1,"k":[{"t":0,"s":[72,72],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":14,"s":[72,72],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":40,"s":[124,124]}]},"d":1},{"ty":"fl","c":{"a":0,"k":[1,1,1,1]},"o":{"a":0,"k":100},"r":1},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":14,"s":[40],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":40,"s":[0]}]},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":90,"st":0,"bm":0,"parent":10},{"ddd":0,"ind":4,"ty":4,"nm":"Ring ripple (white)","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,100,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},"ao":0,"shapes":[{"ty":"gr","nm":"Ring","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":1,"k":[{"t":0,"s":[72,72],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":26,"s":[72,72],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":52,"s":[122,122]}]},"d":1},{"ty":"st","c":{"a":0,"k":[1,1,1,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":1.5},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":26,"s":[70],"o":{"x":[0.22],"y":[1]},"i":{"x":[0.36],"y":[1]}},{"t":52,"s":[0]}]},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":90,"st":0,"bm":0,"parent":10},{"ddd":0,"ind":10,"ty":3,"nm":"Scale 133","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,84,0]},"a":{"a":0,"k":[100,100,0]},"s":{"a":0,"k":[133.33,133.33,100]}},"ao":0,"ip":0,"op":90,"st":0,"bm":0}],"markers":[]}''';

const _failedJson =
    r'''{"v":"5.7.4","fr":60,"ip":0,"op":72,"w":200,"h":168,"nm":"HAAT · Result · failed (one shot)","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":2,"ty":4,"nm":"Cross (icon.primary)","sr":1,"parent":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[0,0,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},"ao":0,"shapes":[{"ty":"gr","nm":"Stroke 1","it":[{"ty":"sh","nm":"A","ks":{"a":0,"k":{"i":[[0,0],[0,0]],"o":[[0,0],[0,0]],"v":[[-7,-7],[7,7]],"c":false}}},{"ty":"tm","s":{"a":0,"k":0},"e":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":10,"s":[0],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":20,"s":[100]}]},"o":{"a":0,"k":0},"m":1},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":3},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]},{"ty":"gr","nm":"Stroke 2","it":[{"ty":"sh","nm":"B","ks":{"a":0,"k":{"i":[[0,0],[0,0]],"o":[[0,0],[0,0]],"v":[[7,-7],[-7,7]],"c":false}}},{"ty":"tm","s":{"a":0,"k":0},"e":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":16,"s":[0],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":26,"s":[100]}]},"o":{"a":0,"k":0},"m":1},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":3},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":72,"st":0,"bm":0},{"ddd":0,"ind":1,"ty":4,"nm":"Status disc 72 (result.disc-bg)","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":1,"k":[{"t":30,"s":[100,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":33,"s":[94,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":36,"s":[106,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":39,"s":[96,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":42,"s":[104,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":45,"s":[98,100,0],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":48,"s":[100,100,0]}]},"a":{"a":0,"k":[0,0,0]},"s":{"a":1,"k":[{"t":0,"s":[0,0,100],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":14,"s":[108,108,100],"o":{"x":[0.32],"y":[0.72]},"i":{"x":[0],"y":[1]}},{"t":25,"s":[100,100,100]}]}},"ao":0,"shapes":[{"ty":"gr","nm":"Disc","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[72,72]},"d":1},{"ty":"fl","c":{"a":0,"k":[1,1,1,1]},"o":{"a":0,"k":30},"r":1},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":72,"st":0,"bm":0,"parent":10},{"ddd":0,"ind":10,"ty":3,"nm":"Scale 133","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,84,0]},"a":{"a":0,"k":[100,100,0]},"s":{"a":0,"k":[133.33,133.33,100]}},"ao":0,"ip":0,"op":82,"st":0,"bm":0}],"markers":[]}''';

const _pendingJson =
    r'''{"v":"5.7.4","fr":60,"ip":0,"op":96,"w":200,"h":168,"nm":"HAAT · Result · pending (loop)","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":3,"ty":4,"nm":"Arc (icon.primary)","sr":1,"parent":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[0,0,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},"ao":0,"shapes":[{"ty":"gr","nm":"Arc","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[58,58]},"d":1},{"ty":"tm","s":{"a":0,"k":0},"e":{"a":0,"k":22},"o":{"a":1,"k":[{"t":0,"s":[0],"o":{"x":[0],"y":[0]},"i":{"x":[1],"y":[1]}},{"t":96,"s":[360]}]},"m":1},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":2.5},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":96,"st":0,"bm":0},{"ddd":0,"ind":2,"ty":4,"nm":"Clock (icon.primary)","sr":1,"parent":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[0,0,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},"ao":0,"shapes":[{"ty":"gr","nm":"Clock","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[19,19]},"d":1},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":2.5},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]},{"ty":"gr","nm":"Hands","it":[{"ty":"sh","nm":"Hands","ks":{"a":0,"k":{"i":[[0,0],[0,0],[0,0]],"o":[[0,0],[0,0],[0,0]],"v":[[0,-5],[0,0],[4,3]],"c":false}}},{"ty":"st","c":{"a":0,"k":[0,0,0,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":2.5},"lc":2,"lj":2,"ml":4},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":96,"st":0,"bm":0},{"ddd":0,"ind":1,"ty":4,"nm":"Status disc 72 (result.disc-bg)","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,100,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":1,"k":[{"t":0,"s":[100,100,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":48,"s":[104,104,100],"o":{"x":[0.45],"y":[0]},"i":{"x":[0.55],"y":[1]}},{"t":96,"s":[100,100,100]}]}},"ao":0,"shapes":[{"ty":"gr","nm":"Disc","it":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[72,72]},"d":1},{"ty":"fl","c":{"a":0,"k":[1,1,1,1]},"o":{"a":0,"k":30},"r":1},{"ty":"tr","p":{"a":0,"k":[0,0]},"a":{"a":0,"k":[0,0]},"s":{"a":0,"k":[100,100]},"r":{"a":0,"k":0},"o":{"a":0,"k":100},"sk":{"a":0,"k":0},"sa":{"a":0,"k":0}}]}],"ip":0,"op":96,"st":0,"bm":0,"parent":10},{"ddd":0,"ind":10,"ty":3,"nm":"Scale 133","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[100,84,0]},"a":{"a":0,"k":[100,100,0]},"s":{"a":0,"k":[133.33,133.33,100]}},"ao":0,"ip":0,"op":106,"st":0,"bm":0}],"markers":[]}''';
