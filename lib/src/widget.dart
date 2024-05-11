import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RxWidget<T> extends StatelessWidget {
  final Subject<T> subject;
  final Widget Function(BuildContext, T) builder;
  final Widget? placeholder;

  const RxWidget(
      {Key? key,
      required this.subject,
      required this.builder,
      this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: subject,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return placeholder ?? const SizedBox.shrink();
        }
        return builder(ctx, snapshot.data!);
      },
    );
  }
}
