import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'stepitemmodel.dart';
export 'stepitemmodel.dart';

class StepItemWidget extends StatefulWidget {
  const StepItemWidget({
    super.key,
    String? duration,
    String? instruction,
    String? number,
  })  : this.duration = duration ?? '10 min',
        this.instruction = instruction ??
            'Pelar y cortar las patatas en láminas finas. Picar la cebolla en trozos pequeños.',
        this.number = number ?? '1';

  final String duration;
  final String instruction;
  final String number;

  @override
  State<StepItemWidget> createState() => _StepItemWidgetState();
}

class _StepItemWidgetState extends State<StepItemWidget> {
  late StepItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary10,
            borderRadius: BorderRadius.circular(9999),
            shape: BoxShape.rectangle,
          ),
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            valueOrDefault<String>(
              '${widget!.number}',
              '1',
            ),
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  lineHeight: 1.4,
                ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                valueOrDefault<String>(
                  widget!.instruction,
                  'Pelar y cortar las patatas en láminas finas. Picar la cebolla en trozos pequeños.',
                ),
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.outfit(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      lineHeight: 1.4,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 14,
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget!.duration,
                      '10 min',
                    ),
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.outfit(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
                          lineHeight: 1.2,
                        ),
                  ),
                ].divide(SizedBox(width: 4)),
              ),
            ].divide(SizedBox(height: 4)),
          ),
        ),
      ].divide(SizedBox(width: 16)),
    );
  }
}
