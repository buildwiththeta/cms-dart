import 'package:flutter/material.dart';

/// A custom FutureBuilder to avoid unwanted calls
class TetaFutureBuilder<T> extends StatefulWidget {
  /// A custom FutureBuilder to avoid unwanted calls
  const TetaFutureBuilder({
    required this.future,
    required this.builder,
    final Key? key,
  }) : super(key: key);

  /// The future
  final Future<T> future;

  /// The builder
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  @override
  State<TetaFutureBuilder<T>> createState() => _TetaFutureBuilderState<T>();
}

class _TetaFutureBuilderState<T> extends State<TetaFutureBuilder<T>> {
  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      builder: widget.builder,
    );
  }
}
