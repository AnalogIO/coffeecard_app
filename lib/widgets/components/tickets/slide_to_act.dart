// Modified version of https://github.com/imtoori/flutter-slide-to-act

// Copyright (c) 2020 Salvatore Giordano
// Copyright (c) 2022 Omid Marfavi

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';

/// Slider call to action component
class SlideAction extends StatefulWidget {
  /// The size of the sliding icon
  final double sliderButtonIconSize;

  /// Tha padding of the sliding icon
  final double sliderButtonIconPadding;

  /// The horizontal gap between the inner circular button and external area.
  final double horizontalPadding;

  /// The child that is rendered instead of the default Text widget
  final Widget? child;

  /// The height of the component
  final double height;

  /// The color of the inner circular button, of the tick icon of the text.
  /// If not set, this attribute defaults to primaryIconTheme.
  final Color? innerColor;

  /// The color of the external area and of the arrow icon.
  /// If not set, this attribute defaults to accentColor from your theme.
  final Color? outerColor;

  /// The text showed in the default Text widget
  final String text;

  /// Text style which is applied on the Text widget.
  ///
  /// By default, the text is colored using [innerColor].
  final TextStyle? textStyle;

  /// The borderRadius of the sliding icon and of the background
  final double borderRadius;

  /// Callback called on submit
  /// If this is null the component will not animate to complete
  final VoidCallback? onSubmit;

  /// Elevation of the component
  final double elevation;

  /// The widget to render instead of the default icon
  final Widget? sliderButtonIcon;

  /// The widget to render instead of the default submitted icon
  final Widget? submittedIcon;

  /// The duration of the animations
  final Duration animationDuration;

  /// Create a new instance of the widget
  const SlideAction({
    Key? key,
    this.sliderButtonIconSize = 24,
    this.sliderButtonIconPadding = 16,
    this.horizontalPadding = 4,
    this.height = 72,
    this.outerColor,
    this.borderRadius = 52,
    this.elevation = 1,
    this.animationDuration = const Duration(milliseconds: 300),
    this.submittedIcon,
    this.onSubmit,
    this.child,
    this.innerColor,
    required this.text,
    this.textStyle,
    this.sliderButtonIcon,
  }) : super(key: key);
  @override
  SlideActionState createState() => SlideActionState();
}

/// Use a GlobalKey to access the state.
/// This is the only way to call [SlideActionState.reset]
class SlideActionState extends State<SlideAction>
    with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _dx = 0;
  double _maxDx = 0;
  double get _progress => _dx == 0 ? 0 : _dx / _maxDx;
  double _endDx = 0;
  double? _containerWidth;
  late AnimationController _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      height: widget.height,
      width: _containerWidth,
      constraints: _containerWidth != null
          ? null
          : BoxConstraints.expand(height: widget.height),
      child: Material(
        elevation: widget.elevation,
        color: widget.outerColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Opacity(
              opacity: 1 - 1 * _progress,
              child: widget.child ??
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: widget.textStyle ??
                        TextStyle(
                          color: widget.innerColor ??
                              Theme.of(context).primaryIconTheme.color,
                          fontSize: 24,
                        ),
                  ),
            ),
            Positioned(
              left: widget.horizontalPadding,
              child: Transform.translate(
                offset: Offset(_dx, 0),
                child: Container(
                  key: _sliderKey,
                  child: GestureDetector(
                    onHorizontalDragUpdate: onHorizontalDragUpdate,
                    onHorizontalDragEnd: (details) async {
                      _endDx = _dx;
                      if (_progress <= 0.8 || widget.onSubmit == null) {
                        _cancelAnimation();
                      } else {
                        widget.onSubmit!();
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      color: widget.innerColor ??
                          Theme.of(context).primaryIconTheme.color,
                      child: Container(
                        padding: EdgeInsets.all(
                          widget.sliderButtonIconPadding,
                        ),
                        child: Center(
                          child: widget.sliderButtonIcon ??
                              Icon(
                                Icons.arrow_forward,
                                size: widget.sliderButtonIconSize,
                                color: widget.outerColor ??
                                    Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
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

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  /// Call this method to revert the animations
  Future reset() async {
    await _cancelAnimation();
  }

  Future _cancelAnimation() async {
    _cancelAnimationController.reset();
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _cancelAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dx = _endDx - (_endDx * animation.value);
        });
      }
    });
    _cancelAnimationController.forward().orCancel;
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final RenderBox containerBox =
          _containerKey.currentContext!.findRenderObject()! as RenderBox;
      _containerWidth = containerBox.size.width;

      final RenderBox sliderBox =
          _sliderKey.currentContext!.findRenderObject()! as RenderBox;
      final sliderWidth = sliderBox.size.width;

      _maxDx = _containerWidth! - sliderWidth - (widget.horizontalPadding * 2);
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    super.dispose();
  }
}
