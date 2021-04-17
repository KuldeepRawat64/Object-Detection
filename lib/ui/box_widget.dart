import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:object_detection/tflite/recognition.dart';

/// Individual bounding box
class BoxWidget extends StatefulWidget {
  final Recognition result;

  const BoxWidget({Key key, this.result}) : super(key: key);

  @override
  State<BoxWidget> createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 100),
        content: const Text('TV detected'),
        action: SnackBarAction(
            label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _showToast(context);
  }

  @override
  Widget build(BuildContext context) {
    // Color for bounding box
    // Color color = Colors.primaries[(widget.result.label.length +
    //         widget.result.label.codeUnitAt(0) +
    //         widget.result.id) %
    //     Colors.primaries.length];
    if (widget.result.label == 'tv') {
      FlutterBeep.beep();
      _showToast(context);
    }

    return Positioned(
      left: widget.result.renderLocation.left,
      top: widget.result.renderLocation.top,
      width: widget.result.renderLocation.width,
      height: widget.result.renderLocation.height,
      child: Container(
        width: widget.result.renderLocation.width,
        height: widget.result.renderLocation.height,
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.result.label == 'tv' ? Colors.red : Colors.amber,
                width: 3),
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: widget.result.label == 'tv' ? Colors.red : Colors.amber,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.result.label,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(" " + widget.result.score.toStringAsFixed(2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
