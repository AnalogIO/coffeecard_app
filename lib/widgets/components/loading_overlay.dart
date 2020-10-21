

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide (){
    Navigator.of(_context).maybePop();
  }
  void show() {
    showDialog(context: _context,
               barrierDismissible: false,
               child: _LoadingScreen());
  }
  LoadingOverlay.__create(this._context);

  factory LoadingOverlay.of(BuildContext context){
    return LoadingOverlay.__create(context);
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
      child: const Center(child: CircularProgressIndicator(),));
  }
}