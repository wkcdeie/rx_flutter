import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RxNavigatorObserver extends NavigatorObserver {
  final _subject = PublishSubject<Route<dynamic>>();

  Subject<Route<dynamic>> asObserver() => _subject;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _subject.add(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _subject.add(newRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _subject.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _subject.add(route);
  }
}
