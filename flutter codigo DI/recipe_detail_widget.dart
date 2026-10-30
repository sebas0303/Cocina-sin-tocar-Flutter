import 'buttonwidget.dart';
import 'ingredientrowwidget.dart';
import 'stepitemwidget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_model.dart';
export 'recipe_detail_model.dart';

class RecipeDetailWidget extends StatefulWidget {
  const RecipeDetailWidget({super.key});

  static String routeName = 'RecipeDetail';
  static String routePath = '/recipeDetail';

  @override
  State<RecipeDetailWidget> createState() => _RecipeDetailWidgetState();
}

class _RecipeDetailWidgetState extends State<RecipeDetailWidget> {
  late RecipeDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeDetailModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8,
                                buttonSize: 40,
                                fillColor: Colors.transparent,
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                              Text(
                                'Tortilla de patatas',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                      lineHeight: 1.3,
                                    ),
                              ),
                            ].divide(SizedBox(width: 16)),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8,
                            buttonSize: 40,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.favorite_border_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    imageUrl:
                                        'https://dimg.dreamflow.cloud/v1/image/Traditional%20Spanish%20tortilla%20de%20patatas%20on%20a%20rustic%20plate',
                                    fit: BoxFit.cover,
                                    alignment: Alignment(0, 0),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primary10,
                                      borderRadius: BorderRadius.circular(9999),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 16, 24, 16),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.restaurant_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .onPrimary,
                                              size: 18,
                                            ),
                                            Text(
                                              '4 raciones',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelLarge
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .onPrimary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                    lineHeight: 1.3,
                                                  ),
                                            ),
                                          ].divide(SizedBox(width: 8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primary10,
                                      borderRadius: BorderRadius.circular(9999),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 16, 24, 16),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.timer_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .onPrimary,
                                              size: 18,
                                            ),
                                            Text(
                                              '45 min',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelLarge
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .onPrimary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                    lineHeight: 1.3,
                                                  ),
                                            ),
                                          ].divide(SizedBox(width: 8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16)),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Ingredientes',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            wrapWithModel(
                                              model: _model.ingredientRowModel1,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: IngredientRowWidget(
                                                name: 'Huevos',
                                                quantity: '6 ud',
                                              ),
                                            ),
                                            wrapWithModel(
                                              model: _model.ingredientRowModel2,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: IngredientRowWidget(
                                                name: 'Patatas',
                                                quantity: '500 g',
                                              ),
                                            ),
                                            wrapWithModel(
                                              model: _model.ingredientRowModel3,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: IngredientRowWidget(
                                                name: 'Cebolla blanca',
                                                quantity: '1 ud',
                                              ),
                                            ),
                                            wrapWithModel(
                                              model: _model.ingredientRowModel4,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: IngredientRowWidget(
                                                name: 'Aceite de oliva',
                                                quantity: '200 ml',
                                              ),
                                            ),
                                            wrapWithModel(
                                              model: _model.ingredientRowModel5,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: IngredientRowWidget(
                                                name: 'Sal',
                                                quantity: 'al gusto',
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16)),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Pasos',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      wrapWithModel(
                                        model: _model.stepItemModel1,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StepItemWidget(
                                          duration: '10 min',
                                          instruction:
                                              'Pelar y cortar las patatas en láminas finas. Picar la cebolla en trozos pequeños.',
                                          number: '1',
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.stepItemModel2,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StepItemWidget(
                                          duration: '20 min',
                                          instruction:
                                              'Freír las patatas y la cebolla en abundante aceite a fuego lento hasta que estén tiernas.',
                                          number: '2',
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.stepItemModel3,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StepItemWidget(
                                          duration: '5 min',
                                          instruction:
                                              'Batir los huevos en un bol grande y añadir la mezcla de patatas escurridas. Salar al gusto.',
                                          number: '3',
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.stepItemModel4,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StepItemWidget(
                                          duration: '10 min',
                                          instruction:
                                              'Cuajar la tortilla en una sartén con un poco de aceite, dándole la vuelta con un plato.',
                                          number: '4',
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 24)),
                                  ),
                                ].divide(SizedBox(height: 16)),
                              ),
                              Container(
                                height: 80,
                              ),
                            ].divide(SizedBox(height: 24)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).background0,
                    FlutterFlowTheme.of(context).primaryBackground
                  ],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, 1),
                  end: AlignmentDirectional(0, -1),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Container(
                  child: wrapWithModel(
                    model: _model.buttonModel,
                    updateCallback: () => safeSetState(() {}),
                    child: ButtonWidget(
                      icon: Icon(
                        Icons.mic_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24,
                      ),
                      iconPresent: true,
                      iconEndPresent: false,
                      content: 'Modo cocina',
                      variant: 'primary',
                      size: 'large',
                      fullWidth: true,
                      loading: false,
                      disabled: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
