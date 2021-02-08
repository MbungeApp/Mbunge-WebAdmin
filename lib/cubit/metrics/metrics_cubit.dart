import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbungeweb/models/metrics.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:meta/meta.dart';

part 'metrics_state.dart';

class MetricsCubit extends Cubit<MetricsState> {
  final MetricsRepo metricsRepo;
  MetricsCubit({@required this.metricsRepo}) : super(MetricsInitial());

  Future<void> fetchMetrics() async {
    try {
      final metrics = await metricsRepo.getHttpPost();
      if (metrics == null) {
        emit(MetricsError(message: "An error occured"));
      } else {
        emit(MetricsSuccess(metrics: metrics));
      }
    } on NetworkException {
      emit(MetricsError(message: "Check your internet connection"));
    } catch (e) {
      emit(MetricsError(message: e.toString()));
    }
  }
}
