import 'buttonwidget.dart';
import 'ingredientrowwidget.dart';
import 'stepitemwidget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'recipe_detail_widget.dart' show RecipeDetailWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipeDetailModel extends FlutterFlowModel<RecipeDetailWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for IngredientRow.
  late IngredientRowModel ingredientRowModel1;
  // Model for IngredientRow.
  late IngredientRowModel ingredientRowModel2;
  // Model for IngredientRow.
  late IngredientRowModel ingredientRowModel3;
  // Model for IngredientRow.
  late IngredientRowModel ingredientRowModel4;
  // Model for IngredientRow.
  late IngredientRowModel ingredientRowModel5;
  // Model for StepItem.
  late StepItemModel stepItemModel1;
  // Model for StepItem.
  late StepItemModel stepItemModel2;
  // Model for StepItem.
  late StepItemModel stepItemModel3;
  // Model for StepItem.
  late StepItemModel stepItemModel4;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    ingredientRowModel1 = createModel(context, () => IngredientRowModel());
    ingredientRowModel2 = createModel(context, () => IngredientRowModel());
    ingredientRowModel3 = createModel(context, () => IngredientRowModel());
    ingredientRowModel4 = createModel(context, () => IngredientRowModel());
    ingredientRowModel5 = createModel(context, () => IngredientRowModel());
    stepItemModel1 = createModel(context, () => StepItemModel());
    stepItemModel2 = createModel(context, () => StepItemModel());
    stepItemModel3 = createModel(context, () => StepItemModel());
    stepItemModel4 = createModel(context, () => StepItemModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    ingredientRowModel1.dispose();
    ingredientRowModel2.dispose();
    ingredientRowModel3.dispose();
    ingredientRowModel4.dispose();
    ingredientRowModel5.dispose();
    stepItemModel1.dispose();
    stepItemModel2.dispose();
    stepItemModel3.dispose();
    stepItemModel4.dispose();
    buttonModel.dispose();
  }
}
