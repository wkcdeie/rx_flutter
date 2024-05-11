import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

extension RxListExtension<E> on List<E> {
  BehaviorSubject<RxList<E>> get rx =>
      _CollectionObserver<RxList<E>>(RxList<E>(this)).subject;
}

extension RxMapExtension<K, V> on Map<K, V> {
  BehaviorSubject<RxMap<K, V>> get rx =>
      _CollectionObserver<RxMap<K, V>>(RxMap<K, V>(this)).subject;
}

extension RxSetExtension<E> on Set<E> {
  BehaviorSubject<RxSet<E>> get rx =>
      _CollectionObserver<RxSet<E>>(RxSet<E>(this)).subject;
}

class RxList<T> extends ChangeNotifier with ListMixin<T> {
  final List<T> _value;

  RxList(this._value);

  @override
  int get length => _value.length;

  @override
  set length(int newLength) {
    _value.length = newLength;
    notifyListeners();
  }

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  Iterable<T> get reversed => _value.reversed;

  @override
  T operator [](int index) {
    return _value[index];
  }

  @override
  void operator []=(int index, T value) {
    _value[index] = value;
    notifyListeners();
  }

  @override
  RxList<T> operator +(List<T> other) {
    addAll(other);
    return this;
  }

  @override
  void add(T element) {
    _value.add(element);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _value.addAll(iterable);
    notifyListeners();
  }

  @override
  bool remove(Object? element) {
    final hasRemoved = _value.remove(element);
    if (hasRemoved) {
      notifyListeners();
    }
    return hasRemoved;
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _value.where(test);
  }

  @override
  Iterable<U> whereType<U>() {
    return _value.whereType<U>();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _value.sort(compare);
    notifyListeners();
  }
}

class RxMap<K, V> extends ChangeNotifier with MapMixin<K, V> {
  final Map<K, V> _value;

  RxMap(this._value);

  @override
  V? operator [](Object? key) {
    return _value[key as K];
  }

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    notifyListeners();
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  Iterable<K> get keys => _value.keys;

  @override
  V? remove(Object? key) {
    final object = _value.remove(key);
    if (object != null) {
      notifyListeners();
    }
    return object;
  }
}

class RxSet<T> extends ChangeNotifier with SetMixin<T> {
  final Set<T> _value;

  RxSet(this._value);

  RxSet<T> operator +(Set<T> other) {
    addAll(other);
    return this;
  }

  @override
  bool add(T value) {
    final hasAdded = _value.add(value);
    if (hasAdded) {
      notifyListeners();
    }
    return hasAdded;
  }

  @override
  bool contains(Object? element) {
    return _value.contains(element);
  }

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  int get length => _value.length;

  @override
  T? lookup(Object? element) {
    return _value.lookup(element);
  }

  @override
  bool remove(Object? value) {
    final hasRemoved = _value.remove(value);
    if (hasRemoved) {
      notifyListeners();
    }
    return hasRemoved;
  }

  @override
  Set<T> toSet() {
    return _value.toSet();
  }

  @override
  void addAll(Iterable<T> elements) {
    _value.addAll(elements);
    notifyListeners();
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _value.retainAll(elements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _value.retainWhere(test);
    notifyListeners();
  }
}

class _CollectionObserver<T extends ChangeNotifier> {
  final T notifier;
  late final BehaviorSubject<T> subject;

  _CollectionObserver(this.notifier) {
    subject = BehaviorSubject.seeded(notifier, onCancel: () {
      notifier.removeListener(_updateValue);
      notifier.dispose();
    });
    notifier.addListener(_updateValue);
  }

  void _updateValue() {
    subject.add(notifier);
  }
}
