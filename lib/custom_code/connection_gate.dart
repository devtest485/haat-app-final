import 'package:flutter/material.dart';

import '/components/no_internet/no_internet_widget.dart';
import '/custom_code/connection_status.dart';

/// Puts the no-internet screen over whatever page is open while HAAT cannot be
/// reached, and takes it away again when it can.
///
/// The page underneath is kept as it was — a half-typed amount is still there when the
/// connection comes back. Wraps the whole app, from `MaterialApp.builder`.
class ConnectionGate extends StatefulWidget {
  const ConnectionGate({super.key, required this.child});

  final Widget child;

  @override
  State<ConnectionGate> createState() => _ConnectionGateState();
}

class _ConnectionGateState extends State<ConnectionGate> {
  final _status = ConnectionStatus.instance;

  @override
  void initState() {
    super.initState();
    _status.offline.addListener(_changed);
    _status.start();
  }

  @override
  void dispose() {
    _status.offline.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    // A keyboard left open under the screen would push it around.
    if (_status.offline.value) FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final offline = _status.offline.value;

    return Stack(
      children: [
        ExcludeSemantics(excluding: offline, child: widget.child),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !offline,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: offline
                  ? NoInternetWidget(
                      key: ValueKey('no-internet'),
                      onRetry: () => _status.check(),
                    )
                  : SizedBox.shrink(key: ValueKey('online')),
            ),
          ),
        ),
      ],
    );
  }
}
