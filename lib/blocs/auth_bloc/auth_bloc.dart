import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/user/user_create_response_model.dart';
import 'package:swafe/models/user/user_model.dart';
import 'package:swafe/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService = UserService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel user = await userService.login(event.email, event.password);
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        ApiResponse<CreateUserResponse> response = await userService.create(
            event.email, event.password, event.firstName, event.lastName);
        await storage.write(
          key: 'token',
          value: response.data!.token,
        );
        await storage.write(
          key: 'emailVerified',
          value: response.data!.user.emailVerified ? 'true' : 'false',
        );
        await storage.write(
          key: 'selfieStatus',
          value: response.data!.user.selfieStatus,
        );
        print(await storage.read(key: 'token'));
        print(await storage.read(key: 'emailVerified'));
        print(await storage.read(key: 'selfieStatus'));
        print(response.data!.user);
        emit(RegisterSuccess(response.data!.user));
      } catch (e) {
        print(e.toString());
        emit(RegisterError(e.toString()));
        throw Exception(e);
      }
    });
  }
}
