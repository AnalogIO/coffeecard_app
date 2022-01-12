import 'package:flutter/material.dart';

class SlideButton extends StatefulWidget {
  final Function() onSwipeComplete;
  //FIXME: dont use constants for screen width, maybe get it from device?
  static double totalWidth = 340;
  static double buttonWidth = 40;
  static double deltaWidth = totalWidth - buttonWidth - buttonWidth / 2;

  const SlideButton({
    required this.onSwipeComplete,
  });

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
        width: SlideButton.totalWidth,
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
            const Center(child: Text('Use ticket')),
            Positioned(
              top: 0,
              bottom: 0,
              left: buttonPosition,
              child: GestureDetector(
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: Container(
                  width: SlideButton.buttonWidth,
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
      if (buttonPosition < 0) {
        buttonPosition = 0;
      } else if (buttonPosition > SlideButton.deltaWidth) {
        buttonPosition = SlideButton.deltaWidth;
        gradient = [
          Colors.white,
          Colors.green,
        ];
      } else {
        gradient = [
          Colors.white,
          Colors.white,
        ];
      }
    });
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
      gradient = [
        Colors.white,
        Colors.white,
      ];

      if (buttonPosition >= SlideButton.deltaWidth) {
        widget.onSwipeComplete();
      }

      buttonPosition = 0;
    });
  }
}
