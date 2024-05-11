import 'package:rxdart/rxdart.dart';

extension SubjectExtension<T> on Subject<T> {
  void valueChanged(T value) => add(value);
}

extension NullableSubjectExtension<T> on NullableSubject<T> {
  void valueChanged(T? value) => add(value);
}

class NullableSubject<T> extends Subject<T?> implements ValueStream<T?> {
  final BehaviorSubject<T?> _subject;

  NullableSubject._(this._subject) : super(_subject, _subject.stream);

  factory NullableSubject.from(T? value) =>
      NullableSubject<T>._(BehaviorSubject<T?>.seeded(value));

  @override
  ValueStream<T?> get stream => _subject.stream;

  @override
  Object get error => _subject.error;

  @override
  Object? get errorOrNull => _subject.errorOrNull;

  @override
  bool get hasError => _subject.hasError;

  @override
  bool get hasValue => _subject.hasValue;

  @override
  StackTrace? get stackTrace => _subject.stackTrace;

  @override
  T? get value => _subject.value;

  set value(T? newValue) => add(newValue);

  @override
  T? get valueOrNull => _subject.valueOrNull;
}
