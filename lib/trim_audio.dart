import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class WaveSlider extends StatefulWidget {
  final double width;
  final Function seekerCallBackEnd;
  final Function seekerCallBackStart;
  const WaveSlider({Key? key, required this.width, required this.seekerCallBackEnd, required this.seekerCallBackStart}) : super(key: key);

  @override
  _WaveSliderState createState() => _WaveSliderState();
}

enum GrowDirection {
  nowhere,
  left,
  right
}

class _WaveSliderState extends State<WaveSlider> {
  double sliderHeight = 100;
  double selectedGrowth = 0;
  double startSelectionFrom = 0;
  double startSelectionFromImmutable = 0;
  GrowDirection? growDirection;

  double seekerStartFrom = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragStart: (_) {
            widget.seekerCallBackStart();
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              if(seekerStartFrom > MediaQuery.of(context).size.width - 40) {
                seekerStartFrom = MediaQuery.of(context).size.width - 40;
              } else if(seekerStartFrom < 0) {
                seekerStartFrom = 0;
              } else {
                seekerStartFrom += details.delta.dx;
              }
            });
          },
          onHorizontalDragEnd: (_) {
            widget.seekerCallBackEnd(seekerStartFrom, context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            color: Colors.black54,
            child: Stack(
              children: [
                Positioned(
                  left: seekerStartFrom < 0 ? 0 : seekerStartFrom,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragStart: (details) {
            setState(() {
              startSelectionFrom = details.globalPosition.dx;
              startSelectionFromImmutable = startSelectionFrom;
              selectedGrowth = 0;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              growDirection = details.globalPosition.dx -  startSelectionFromImmutable == 0 ?
              GrowDirection.nowhere : details.globalPosition.dx -  startSelectionFromImmutable > 0 ? GrowDirection.right : GrowDirection.left;
            });
            setState(() {
              if(growDirection == GrowDirection.left) {
                startSelectionFrom = details.globalPosition.dx;
                selectedGrowth += details.delta.dx;
              } else if(growDirection == GrowDirection.right) {
                selectedGrowth += details.delta.dx;
              }
            });
          },
          child: Container(
            width: widget.width,
            height: sliderHeight,
            color: Colors.black.withOpacity(0.2),
            child: Stack(
              children: [
                Positioned(
                  left: startSelectionFrom,
                  child: Container(
                    height: sliderHeight,
                    width: selectedGrowth.abs(),
                    color: Colors.blue.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
