import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/user/user_model.dart';
import 'package:swafe/models/user/user_response_model.dart';
import 'package:swafe/models/user/user_token_response_model.dart';
import 'package:swafe/models/user/user_selfie_response_model.dart';
import 'package:swafe/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService = UserService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserModel? user;

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        ApiResponse<UserTokenResponse> response =
            await userService.login(event.email, event.password);

        if (response.status == Status.error) {
          emit(LoginError(response.message));
          return;
        }

        // Comment this verification until backend is ready for sending email
        // if (response.data!.user.emailVerified == false) {
        //   emit(LoginEmailNotVerified());
        //   return;
        // }

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

        user = response.data?.user;
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        ApiResponse<UserTokenResponse> response = await userService.create(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
          event.phoneNumber,
          event.phoneCountryCode,
        );

        if (response.status == Status.error) {
          emit(RegisterError(response.message));
          return;
        }

        await storage.write(
          key: 'token',
          value: response.data!.token,
        );
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<UploadSelfieEvent>((event, emit) async {
      emit(UploadSelfieLoading());
      try {
        ApiResponse<SelfieUserResponse> response =
            await userService.uploadSelfie(event.file);

        if (response.status == Status.error) {
          emit(UploadSelfieError(response.message));
          return;
        }

        emit(UploadSelfieSuccess());
      } catch (e) {
        emit(UploadSelfieError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<VerifyTokenEvent>((event, emit) async {
      emit(VerifyTokenLoading());
      try {
        String? token = await storage.read(key: 'token');

        if (token == null) {
          emit(VerifyTokenError());
          return;
        }

        ApiResponse<UserTokenResponse> response =
            await userService.getOne(token);

        if (response.status ==
                Status.error /* || !response.data!.user.emailVerified */ ||
            response.data!.user.selfieStatus != 'validated') {
          emit(VerifyTokenError());
          return;
        }

        await storage.write(
          key: 'token',
          value: response.data!.token,
        );

        user = response.data?.user;
        emit(VerifyTokenSuccess());
      } catch (e) {
        emit(VerifyTokenError());
        throw Exception(e);
      }
    });
    on<SignOutEvent>((event, emit) async {
      await storage.delete(key: 'token');
      emit(AuthInitial());
    });
    on<DeleteUserEvent>((event, emit) async {
      emit(DeleteUserLoading());
      try {
        ApiResponse response = await userService.delete();

        if (response.status == Status.error) {
          emit(DeleteUserError(response.message));
          return;
        }

        await storage.delete(key: 'token');
        emit(DeleteUserSuccess());
        emit(AuthInitial());
      } catch (e) {
        emit(DeleteUserError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        ApiResponse<UserResponse> response = await userService.update(
          event.email,
          event.firstName,
          event.lastName,
          event.phoneNumber,
          event.phoneCountryCode,
        );

        if (response.status == Status.error) {
          emit(UpdateUserError(response.message));
          return;
        }

        user = response.data?.user;
        emit(UpdateUserSuccess());
      } catch (e) {
        emit(UpdateUserError("Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
  }
}
