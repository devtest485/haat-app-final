import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'no_internet_model.dart';
export 'no_internet_model.dart';

/// HAAT could not be reached: the no-signal icon in the middle, a heading, a line on
/// what to do, and Retry under them.
///
/// [onRetry] tries again; the button waits on it, so a second tap cannot send twice.
/// Without one, Retry goes back to the screen before.
class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({
    super.key,
    this.title,
    this.message,
    this.retryLabel,
    this.onRetry,
  });

  final String? title;
  final String? message;
  final String? retryLabel;
  final Future<void> Function()? onRetry;

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  late NoInternetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoInternetModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> _retry() async {
    if (_model.retrying) return;

    if (widget.onRetry == null) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      return;
    }

    safeSetState(() => _model.retrying = true);
    try {
      await widget.onRetry!();
    } finally {
      if (mounted) safeSetState(() => _model.retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Material, because the screen may be shown above the app's navigator, where there
    // is none to give the text its style and the button its ink.
    return Material(
      color: theme.secondaryBackground,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Glossy green Wi-Fi alert icon.png',
                    width: 220.0,
                    fit: BoxFit.contain,
                    cacheWidth: 660,
                    semanticLabel: 'No internet',
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Semantics(
                      header: true,
                      child: Text(
                        widget.title ?? 'No internet connection',
                        textAlign: TextAlign.center,
                        style: theme.headlineSmall.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.headlineSmall.fontStyle,
                          ),
                          color: theme.primaryBackground,
                          fontSize: 22.0,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.headlineSmall.fontStyle,
                          lineHeight: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300.0),
                      child: Text(
                        widget.message ??
                            'Check your Wi-Fi or mobile data, then try again.',
                        textAlign: TextAlign.center,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: Color(0xFF484848),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: theme.bodyMedium.fontStyle,
                          lineHeight: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Semantics(
                      button: true,
                      enabled: !_model.retrying,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: _model.retrying ? null : _retry,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          width: 180.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: _model.retrying
                                ? Color(0xFF484848)
                                : theme.primaryBackground,
                            borderRadius: BorderRadius.circular(106.67),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: _model.retrying
                              ? SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primaryText,
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.retryLabel ?? 'Retry',
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: theme.primaryText,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
