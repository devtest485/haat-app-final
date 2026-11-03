import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'security_sheet_model.dart';
export 'security_sheet_model.dart';

/// Bottom sheet holding the SecuritySettings panel, opened from the home
/// screen's Security button.
class SecuritySheetWidget extends StatefulWidget {
  const SecuritySheetWidget({super.key});

  @override
  State<SecuritySheetWidget> createState() => _SecuritySheetWidgetState();
}

class _SecuritySheetWidgetState extends State<SecuritySheetWidget> {
  late SecuritySheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecuritySheetModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: custom_widgets.SecuritySettings(),
      ),
    );
  }
}
