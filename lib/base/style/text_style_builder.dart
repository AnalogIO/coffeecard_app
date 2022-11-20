import 'dart:ui';

import 'package:flutter/material.dart';

class TextStyleBuilder {
  TextStyleBuilder._({
    required _AnalogFontFamily fontFamily,
    double? fontSize,
    double? fontWeight,
    Color? color,
    TextDecoration? decoration,
  })  : _fontFamily = fontFamily,
        _fontSize = fontSize,
        _fontWeight = fontWeight,
        _color = color,
        _decoration = decoration;

  final _AnalogFontFamily _fontFamily;
  final double? _fontSize;
  final double? _fontWeight;
  final Color? _color;
  final TextDecoration? _decoration;

  /// Begin building a text style with a heading font.
  ///
  /// Returns a [_TextStyleBuilderWithoutSize] that needs to be completed
  /// with a font size. Once supplied, the text style can be further
  /// customized with setter methods and built with the `style` getter.
  ///
  /// Example:
  ///
  /// ```dart
  /// // with font size and optical sizing
  /// final TextStyle smallBody = TextStyleBuilder.heading.size(12).style;
  /// // with inherited font size (inherit from parent, disables optical sizing)
  /// final TextStyle body = TextStyleBuilder.heading.inheritSize().style;
  /// ```
  static _TextStyleBuilderWithoutSize get heading =>
      _TextStyleBuilderWithoutSize._(fontFamily: _AnalogFontFamily.heading);

  /// Begin building a text style with a body font.
  ///
  /// Returns a [_TextStyleBuilderWithoutSize] that needs to be completed
  /// with a font size. Once supplied, the text style can be further
  /// customized with setter methods and built with the `style` getter.
  ///
  /// Example:
  ///
  /// ```dart
  /// // with font size and optical sizing
  /// final TextStyle smallBody = TextStyleBuilder.body.size(12).style;
  /// // with inherited font size (inherit from parent, disables optical sizing)
  /// final TextStyle body = TextStyleBuilder.body.inheritSize().style;
  /// ```
  static _TextStyleBuilderWithoutSize get body =>
      _TextStyleBuilderWithoutSize._(fontFamily: _AnalogFontFamily.body);

  /// Begin building a text style with a monospaced font.
  ///
  /// Returns a [_TextStyleBuilderWithoutSize] that needs to be completed
  /// with a font size. Once supplied, the text style can be further
  /// customized with setter methods and built with the `style` getter.
  ///
  /// Example:
  ///
  /// ```dart
  /// // with font size
  /// final TextStyle smallMono = TextStyleBuilder.mono.size(12).style;
  /// // with inherited font size (will inherit from parent)
  /// final TextStyle mono = TextStyleBuilder.mono.inheritSize().style;
  /// ```
  static _TextStyleBuilderWithoutSize get mono =>
      _TextStyleBuilderWithoutSize._(fontFamily: _AnalogFontFamily.mono);

  /// Set the font color to the given [color].
  TextStyleBuilder color(Color color) {
    return _copyWith(color: color);
  }

  /// Set the text decoration to the given [TextDecoraiton].
  TextStyleBuilder decoration(TextDecoration decoration) {
    return _copyWith(decoration: decoration);
  }

  /// Set the font weight using the wght axis or the FontWeight enum
  /// depending on font support.
  TextStyleBuilder weight(double fontWeight) {
    return _copyWith(fontWeight: fontWeight);
  }

  /// Set the font size and optical size (for the fonts that support it).
  TextStyleBuilder size(double fontSize) {
    return _copyWith(fontSize: fontSize);
  }

  /// Set the text decoration to [TextDecoration.underline].
  TextStyleBuilder underline() =>
      _copyWith(decoration: TextDecoration.underline);

  /// Set the font weight to regular (default for body and mono text).
  TextStyleBuilder regular() => _copyWith(fontWeight: 400);

  /// Set the font weight to medium.
  TextStyleBuilder medium() => _copyWith(fontWeight: 500);

  /// Set the font weight to bold (default for heading text).
  TextStyleBuilder bold() => _copyWith(fontWeight: 700);

  /// Set the font weight to extrabold.
  TextStyleBuilder extrabold() => _copyWith(fontWeight: 800);

  TextStyleBuilder _copyWith({
    _AnalogFontFamily? fontFamily,
    double? fontSize,
    double? fontWeight,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyleBuilder._(
      fontFamily: fontFamily ?? _fontFamily,
      fontSize: fontSize ?? _fontSize,
      fontWeight: fontWeight ?? _fontWeight,
      color: color ?? _color,
      decoration: decoration ?? _decoration,
    );
  }

  /// Get the corresponding [TextStyle].
  TextStyle get style => _build();

  TextStyle _build() {
    final double defaultFontWeight =
        _fontFamily == _AnalogFontFamily.heading ? 700 : 400;

    final fontVariations = [
      FontVariation('wght', _fontWeight ?? defaultFontWeight),
      if (_fontSize != null) FontVariation('opsz', _fontSize!),
      if (_fontFamily == _AnalogFontFamily.heading) ..._headingParametricAxes,
      if (_fontFamily == _AnalogFontFamily.body) ..._bodyParametricAxes,
    ];

    final fontFamilyString =
        _fontFamily == _AnalogFontFamily.mono ? 'RobotoMono' : 'RobotoFlex';

    final letterSpacing = _fontFamily == _AnalogFontFamily.body ? 0.25 : null;

    final fontWeight =
        _fontWeights[_fontWeight?.toInt() ?? defaultFontWeight.toInt()];

    return TextStyle(
      fontFamily: fontFamilyString,
      fontSize: _fontSize,
      fontWeight: fontWeight,
      color: _color,
      decoration: _decoration,
      fontVariations: fontVariations,
      letterSpacing: letterSpacing,
    );
  }
}

/// The type returned by [TextStyleBuilder.heading], [TextStyleBuilder.body],
/// and [TextStyleBuilder.mono].
///
/// This forces the user to specify a size (either fixed or inherited)
/// before building the rest of the text style.
class _TextStyleBuilderWithoutSize {
  _TextStyleBuilderWithoutSize._({required _AnalogFontFamily fontFamily})
      : _fontFamily = fontFamily;

  final _AnalogFontFamily _fontFamily;

  /// Set font size and optical size (for the fonts that support it).
  TextStyleBuilder size(double fontSize) {
    return TextStyleBuilder._(fontFamily: _fontFamily, fontSize: fontSize);
  }

  /// Inherit the font size from the parent widget, but
  /// do not set optical size (for the fonts the support it).
  TextStyleBuilder inheritSize() {
    return TextStyleBuilder._(fontFamily: _fontFamily);
  }
}

enum _AnalogFontFamily { heading, body, mono }

const _bodyParametricAxes = [
  FontVariation('wdth', 108), // width axis
  FontVariation('XOPQ', 96), // parametric thick stroke axis
  FontVariation('YOPQ', 79), // parametric thin stroke axis
  FontVariation('XTRA', 468), // paramatric counter width axis
  FontVariation('YTUC', 712), // parametric upper case axis
  FontVariation('YTLC', 514), // parametric lower case axis
  FontVariation('YTAS', 750), // parametric ascender height axis
  FontVariation('YTDE', -203), // parametric descender depth axis
  FontVariation('YTFI', 750), // parametric figure height axis
];

const _headingParametricAxes = [
  FontVariation('wdth', 100), // width axis
  FontVariation('GRAD', -25), // grade axis
  FontVariation('XOPQ', 96), // parametric thick stroke axis
  FontVariation('YOPQ', 79), // parametric thin stroke axis
  FontVariation('XTRA', 468), // paramatric counter width axis
  FontVariation('YTUC', 712), // parametric upper case axis
  FontVariation('YTLC', 539), // parametric lower case axis
  FontVariation('YTAS', 685), // parametric ascender height axis
  FontVariation('YTDE', -178), // parametric descender depth axis
  FontVariation('YTFI', 735), // parametric figure height axis
];

// Map font weights to FontWeight enum values.
const Map<int, FontWeight> _fontWeights = {
  100: FontWeight.w100,
  200: FontWeight.w200,
  300: FontWeight.w300,
  400: FontWeight.w400,
  500: FontWeight.w500,
  600: FontWeight.w600,
  700: FontWeight.w700,
  800: FontWeight.w800,
  900: FontWeight.w900,
};
