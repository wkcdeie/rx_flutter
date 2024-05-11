import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

extension RxTabController on TabController {
  BehaviorSubject<int> get rx => _TabControllerObserver(this).subject;
}

extension RxPageController on PageController {
  BehaviorSubject<int> get rx => _PageControllerObserver(this).subject;
}

extension RxTextEditingController on TextEditingController {
  BehaviorSubject<String> get rx =>
      _TextEditingControllerObserver(this).subject;
}

extension RxScrollController on ScrollController {
  BehaviorSubject<ScrollPosition?> get rx =>
      _ScrollControllerObserver(this).subject;
}

extension RxFocusNode on FocusNode {
  BehaviorSubject<bool> get rx => _FocusNodeObserver(this).subject;
}

extension RxAnimationController on AnimationController {
  BehaviorSubject<double> get rx => _AnimationControllerObserver(this).subject;
}

class _TabControllerObserver {
  final TabController _controller;
  late final BehaviorSubject<int> subject;

  _TabControllerObserver(this._controller) {
    subject = BehaviorSubject<int>.seeded(_controller.index, onCancel: () {
      _controller.removeListener(_updateValue);
    });
    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    subject.add(_controller.index);
  }
}

class _PageControllerObserver {
  final PageController _controller;
  late final BehaviorSubject<int> subject;

  int get _page {
    if (!_controller.hasClients) {
      return _controller.initialPage;
    }
    return _controller.page?.toInt() ?? _controller.initialPage;
  }

  _PageControllerObserver(this._controller) {
    subject = BehaviorSubject<int>.seeded(_page, onCancel: () {
      _controller.removeListener(_updateValue);
    });
    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    if (!_controller.hasClients) {
      return;
    }
    final page = _controller.page;
    if (page != null) {
      subject.add(page.toInt());
    }
  }
}

class _TextEditingControllerObserver {
  final TextEditingController _controller;
  late final BehaviorSubject<String> subject;

  _TextEditingControllerObserver(this._controller) {
    subject = BehaviorSubject<String>.seeded(_controller.text, onCancel: () {
      _controller.removeListener(_updateValue);
    });
    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    subject.add(_controller.text);
  }
}

class _ScrollControllerObserver {
  final ScrollController _controller;
  late final BehaviorSubject<ScrollPosition?> subject;

  _ScrollControllerObserver(this._controller) {
    subject = BehaviorSubject<ScrollPosition?>.seeded(
        _controller.hasClients ? _controller.position : null, onCancel: () {
      _controller.removeListener(_updateValue);
    });
    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    if (_controller.hasClients) {
      _controller.offset;
      subject.add(_controller.position);
    }
  }
}

class _FocusNodeObserver {
  final FocusNode _focusNode;
  late final BehaviorSubject<bool> subject;

  _FocusNodeObserver(this._focusNode) {
    subject = BehaviorSubject<bool>.seeded(_focusNode.hasFocus, onCancel: () {
      _focusNode.removeListener(_updateValue);
    });
    _focusNode.addListener(_updateValue);
  }

  void _updateValue() {
    subject.add(_focusNode.hasFocus);
  }
}

class _AnimationControllerObserver {
  final AnimationController _controller;
  late final BehaviorSubject<double> subject;

  _AnimationControllerObserver(this._controller) {
    subject = BehaviorSubject<double>.seeded(_controller.value, onCancel: () {
      _controller.removeListener(_updateValue);
    });
    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    subject.add(_controller.value);
  }
}
