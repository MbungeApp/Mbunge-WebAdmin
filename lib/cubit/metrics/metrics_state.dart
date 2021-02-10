part of 'metrics_cubit.dart';

@immutable
abstract class MetricsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MetricsInitial extends MetricsState {}

class MetricsSuccess extends MetricsState {
  final Metrics metrics;

  MetricsSuccess({@required this.metrics});
  @override
  List<Object> get props => [metrics];
}

class MetricsError extends MetricsState {
  final String message;
  MetricsError({@required this.message});

  @override
  List<Object> get props => [message];
}
