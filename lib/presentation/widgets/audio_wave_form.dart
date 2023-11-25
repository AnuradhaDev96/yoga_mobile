import 'dart:async';

import 'package:flutter/material.dart';

class WaveBar {
  WaveBar({
    required this.heightFactor,
    this.color = Colors.red,
    this.radius = 50.0,
    this.gradient,
  })  : assert(heightFactor <= 1),
        assert(heightFactor >= 0);

  /// [heightFactor] is the height of the bar based. It is percentage rate of widget height.
  ///
  /// If it's set to 0.5, then it will be 50% height from the widget height.
  ///
  /// [heightFactor] of bar must be between 0 to 1. Or There will be side effect.
  double heightFactor;

  /// [color] is the color of the bar
  Color color;

  /// [radius] is the radius of bar
  double radius;

  /// [gradient] is the gradient of bar
  final Gradient? gradient;
}

class AudioWaveForm extends StatefulWidget {
  const AudioWaveForm(
      {required this.bars,
      this.height = 100,
      // this.width = 200,
      this.spacing = 5,
      this.thickness = 2,
      this.alignment = 'center',
      this.animation = true,
      this.animationLoop = 0,
      this.beatRate = const Duration(milliseconds: 200),
      Key? key})
      : super(key: key);
  final List<WaveBar> bars;

  /// [height] is the height of the widget.
  ///
  final double height;

  /// [width] is the width of the widget. Input the
  // final double width;

  /// [thickness] is the width of a bar
  final double thickness;

  /// [spacing] is the spaces between bars.
  final double spacing;

  /// [alignment] is the alignment of bars. It can be one of 'top', 'center', 'bottom'.
  final String alignment;

  /// [animation] if it is set to true, then the bar will be animated.
  final bool animation;

  /// [animationLoop] limits no of loops. If it is set to 0, then it loops forever. default is 0.
  final int animationLoop;

  /// [beatRate] plays how fast/slow the bar animates.
  final Duration beatRate;

  @override
  _AudioWaveFormState createState() => _AudioWaveFormState();
}

class _AudioWaveFormState extends State<AudioWaveForm> {
  int countBeat = 0;

  List<WaveBar> bars = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.animation) {
      bars = [];

      WidgetsBinding.instance.addPostFrameCallback((x) {
        timer = Timer.periodic(widget.beatRate, (timer) {
          if (widget.bars.isEmpty) {
            bars = [];
          } else {
            int mo = countBeat % widget.bars.length;
            bars = List.from(widget.bars.getRange(0, mo + 1));
          }
          if (mounted) setState(() {});
          countBeat++;

          if (widget.animationLoop > 0 && widget.animationLoop <= (countBeat / widget.bars.length)) {
            timer.cancel();
          }
        });
      });
    } else {
      bars = widget.bars;
    }
  }

  @override
  void didUpdateWidget(AudioWaveForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    bars = widget.bars;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // double width = (widget.width - (widget.spacing * widget.bars.length)) /
    //     widget.bars.length;

    return SizedBox(
      height: widget.height,
      // width: widget.width,
      child: Row(
        crossAxisAlignment: widget.alignment == 'top'
            ? CrossAxisAlignment.start
            : widget.alignment == 'bottom'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
        children: [
          for (final bar in bars)
            Container(
              height: bar.heightFactor * widget.height,
              width: widget.thickness,
              margin: EdgeInsets.symmetric(horizontal: widget.spacing),
              decoration: BoxDecoration(
                gradient: bar.gradient,
                color: bar.color,
                borderRadius: BorderRadius.circular(bar.radius),
              ),
            ),
        ],
      ),
    );
  }
}
