import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

extension RxIntExtension on int {
  BehaviorSubject<int> get rx => _ValueObserver(this)._subject;
}

extension RxDoubleExtension on double {
  BehaviorSubject<double> get rx => _ValueObserver(this)._subject;
}

extension RxNumExtension on num {
  BehaviorSubject<num> get rx => _ValueObserver(this)._subject;
}

extension RxBoolExtension on bool {
  BehaviorSubject<bool> get rx => _ValueObserver(this)._subject;
}

extension RxStringExtension on String {
  BehaviorSubject<String> get rx => _ValueObserver(this)._subject;
}

class _ValueObserver<T> {
  late final ValueNotifier<T> _valueNotifier;
  late final BehaviorSubject<T> _subject;

  _ValueObserver(T value) {
    _valueNotifier = ValueNotifier<T>(value);
    _subject = BehaviorSubject<T>.seeded(value, onCancel: () {
      _valueNotifier.removeListener(_updateValue);
      _valueNotifier.dispose();
    });
    _valueNotifier.addListener(_updateValue);
  }

  void _updateValue() {
    _subject.add(_valueNotifier.value);
  }
}
