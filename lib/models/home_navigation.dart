import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/models/user_model.dart';

class HomeNavigationModel {
  final String token;
  final UserModel userModel;
  final LoginCubit loginCubit;

  HomeNavigationModel(this.token, this.userModel, this.loginCubit);
}
