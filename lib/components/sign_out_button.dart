import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/backend/auth/auth_session.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';

/// Signs the current account out.
///
/// Asks first. Signing out is not destructive in the sense of losing data, but it does
/// end the session on this handset and put the owner back at the start — and it sits in
/// a header beside two icons that do far smaller things, which is exactly where a
/// mis-tap happens.
class SignOutButton extends StatefulWidget {
  const SignOutButton({super.key, this.size = 24.0});

  /// Matched to the icons it sits beside in the header.
  final double size;

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  bool _signingOut = false;

  Future<void> _confirmThenSignOut() async {
    if (_signingOut) return;

    // Read before any await, not after.
    //
    // `mounted` stays true while an element is merely deactivated, and an ancestor
    // lookup then throws — the same hazard `ApiFeedback` documents. Both of these are
    // looked up now, while this context is certainly alive.
    final router = GoRouter.of(context);
    final theme = FlutterFlowTheme.of(context);

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SignOutSheet(
        // `secondary` rather than `secondaryBackground`: the latter is near-white in
        // this theme while `primaryText` is white, which renders a sheet nobody can
        // read. This is the dark card colour the rest of the app uses.
        surface: theme.secondary,
        onSurface: theme.primaryText,
        muted: theme.secondaryText,
        danger: theme.error,
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() => _signingOut = true);

    // Clears the local tokens whatever the server answers, so this always completes.
    await AuthSession.instance.signOut();

    if (!mounted) return;
    setState(() => _signingOut = false);

    // The router carries no auth-status redirect, so signing out moves nowhere on its
    // own. The sign-in screen navigates explicitly for the same reason.
    router.goNamed(OnBoardingPageWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final tint = FlutterFlowTheme.of(context).primaryText;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _signingOut
          ? Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(tint),
              ),
            )
          : IconButton(
              padding: EdgeInsets.zero,
              iconSize: widget.size,
              visualDensity: VisualDensity.compact,
              tooltip: 'Sign out',
              icon: Icon(Icons.logout, color: tint, size: widget.size),
              onPressed: _confirmThenSignOut,
            ),
    );
  }
}

class _SignOutSheet extends StatelessWidget {
  const _SignOutSheet({
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.danger,
  });

  final Color surface;
  final Color onSurface;
  final Color muted;
  final Color danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Sign out?',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                // Deliberately not a list of the ways back in. Which of them this handset
                // actually offers depends on what is set up on it, and a sheet that
                // names the wrong one is worse than one that names none.
                'You will need to sign in again to get back in.',
                // Softened white rather than the theme's `secondaryText`, which is a
                // mid slate that all but disappears on this dark a ground.
                style: TextStyle(
                  color: onSurface.withValues(alpha: 0.75),
                  fontSize: 15.0,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
