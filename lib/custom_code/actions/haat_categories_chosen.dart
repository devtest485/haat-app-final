// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Whether the merchant has picked at least one category. Empty means they have.
///
/// The screen's own condition was `(selectedCategories.isNotEmpty) != null` — a
/// bool compared to null, which is true whatever the list holds, so Continue moved
/// on from an empty selection and the counter beside it was always in its chosen
/// colour. Asked in Dart because the DSL has no "list is not empty" expression,
/// and a wrong answer here is the difference between a business with categories
/// and one without.
///
/// Empty-means-yes matches every other action here: the caller compares against
/// '' and shows whatever else it gets.
Future<String> haatCategoriesChosen() async =>
    FFAppState().selectedCategories.isEmpty
        ? 'Choose at least one category to continue.'
        : '';
