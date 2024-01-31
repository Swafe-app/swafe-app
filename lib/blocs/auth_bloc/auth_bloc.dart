import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/user/user_create_response_model.dart';
import 'package:swafe/models/user/user_login_response_model.dart';
import 'package:swafe/models/user/user_model.dart';
import 'package:swafe/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService = UserService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        ApiResponse<LoginUserResponse> response =
            await userService.login(event.email, event.password);

        if (response.status == Status.ERROR) {
          emit(LoginError(response.message));
          return;
        }

        if (response.data!.user.emailVerified == false) {
          emit(LoginError("Veuillez vérifier votre email pour continuer."));
          return;
        }

        if (response.data!.user.selfieStatus == 'pending') {
          emit(LoginError("Votre photo est en cours de validation."));
          return;
        }

        await storage.write(
          key: 'token',
          value: response.data!.token,
        );

        if (response.data!.user.selfieStatus == 'refused' ||
            response.data!.user.selfieStatus == 'not_defined') {
          emit(LoginSelfieRedirect());
          return;
        }

        emit(LoginSuccess(response.data!.user));
      } catch (e) {
        emit(LoginError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        ApiResponse<CreateUserResponse> response = await userService.create(
            event.email, event.password, event.firstName, event.lastName);

        if (response.status == Status.ERROR) {
          emit(RegisterError(response.message));
          return;
        }

        await storage.write(
          key: 'token',
          value: response.data!.token,
        );
        emit(RegisterSuccess(response.data!.user));
      } catch (e) {
        emit(RegisterError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
  }
}
