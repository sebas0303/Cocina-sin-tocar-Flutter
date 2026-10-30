import 'buttonwidget.dart';
import 'stepdisplaywidget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'index.dart';
import 'handsfreecookingmode_widget.dart' show HandsFreeCookingModeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class HandsFreeCookingModeModel
    extends FlutterFlowModel<HandsFreeCookingModeWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for StepDisplay.
  late StepDisplayModel stepDisplayModel;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    stepDisplayModel = createModel(context, () => StepDisplayModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    stepDisplayModel.dispose();
    buttonModel.dispose();
  }
}
