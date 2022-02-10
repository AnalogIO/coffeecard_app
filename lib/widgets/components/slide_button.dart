import 'package:coffeecard/base/strings.dart';
import 'package:flutter/material.dart';

class SlideButton extends StatefulWidget {
  final Function() onSwipeComplete;
  final double width;
  late final double buttonWidth;
  late final double activationZone;
  late final double startButtonPosition;
  late final double endButtonPosition;

  final List<Color> gradientOff = [
    Colors.white,
    Colors.white,
  ];
  final List<Color> gradientOn = [
    Colors.white,
    Colors.green,
  ];

  SlideButton({
    required this.width,
    required this.onSwipeComplete,
  }) {
    buttonWidth = 40;
    startButtonPosition = 0;
    endButtonPosition = width - buttonWidth - buttonWidth / 2;
    activationZone = endButtonPosition * 0.85;
  }

  @override
  _SlideButtonState createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  List<Color> gradient = [
    Colors.white,
    Colors.white,
  ];
  double buttonPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: widget.width,
        height: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            colors: gradient,
          ),
        ),
        child: Stack(
          children: <Widget>[
            const Center(child: Text(Strings.useTicket)),
            Positioned(
              top: 0,
              bottom: 0,
              left: buttonPosition,
              child: GestureDetector(
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: Container(
                  width: widget.buttonWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_right,
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

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      buttonPosition += details.delta.dx;
      if (buttonPosition < widget.startButtonPosition) {
        buttonPosition = widget.startButtonPosition;
      } else if (buttonPosition > widget.endButtonPosition) {
        buttonPosition = widget.endButtonPosition;
        gradient = widget.gradientOn;
      }
      if (buttonPosition >= widget.activationZone) {
        gradient = widget.gradientOn;
      } else {
        gradient = widget.gradientOff;
      }
    });
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
      gradient = widget.gradientOff;

      if (buttonPosition >= widget.activationZone) {
        widget.onSwipeComplete();
      }

      buttonPosition = widget.startButtonPosition;
    });
  }
}
