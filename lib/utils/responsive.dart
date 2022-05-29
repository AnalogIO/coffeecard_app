import 'package:flutter/material.dart';

/// Returns `true` if the device is <= 325 px wide.
bool deviceIsSmall(BuildContext context) =>
    MediaQuery.of(context).size.width <= 325;
