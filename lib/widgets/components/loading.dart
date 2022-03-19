import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({required this.loading, this.child = const SizedBox.shrink()});

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading,
      child: Stack(
        children: [
          if (loading) const LinearProgressIndicator(),
          AnimatedOpacity(
            opacity: loading ? 0.4 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: child,
          ),
        ],
      ),
    );
  }
}
