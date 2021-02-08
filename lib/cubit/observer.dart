import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/utils/logger.dart';

class ActionState {
  final String message;
  final bool isSuccess;

  ActionState(this.message, this.isSuccess);
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    AppLogger.logInfo('onCreate -- cubit: ${cubit.runtimeType}');
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    AppLogger.logDebug(
        'onChange -- cubit: ${cubit.runtimeType}, change: $change');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    AppLogger.logError('onError -- cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    AppLogger.logWarning('onClose -- cubit: ${cubit.runtimeType}');
  }
}
