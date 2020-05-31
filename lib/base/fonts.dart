import 'dart:io';
import 'package:flutter/material.dart';

abstract class AppFont {
  static final String heading = Platform.isIOS ? 'SF UI Display' : 'Roboto';
  static final String body = Platform.isIOS ? 'SF UI Text' : 'Roboto';
  static final String mono = Platform.isIOS ? 'SF UI Mono' : 'Roboto Mono';
}
