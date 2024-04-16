import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_event.dart';
import 'package:swafe/blocs/signalement_bloc/signalement_state.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/signalement/signalement_downvote_response_model.dart';
import 'package:swafe/models/signalement/signalement_model.dart';
import 'package:swafe/models/signalement/signalement_upvote_response_model.dart';
import 'package:swafe/services/signalement_service.dart';

class SignalementBloc extends Bloc<SignalementEvent, SignalementState> {
  final SignalementService signalementService = SignalementService();
  List<SignalementModel>? signalements;

  SignalementBloc() : super(SignalementInitial()) {
    on<CreateSignalementEvent>((event, emit) async {
      emit(CreateSignalementLoading());
      try {
        ApiResponse<SignalementModel> response =
            await signalementService.createSignalement(
          event.coordinates,
          event.selectedDangerItems,
        );

        if (response.status == Status.error) {
          emit(CreateSignalementError(response.message));
          return;
        }

        signalements!.add(response.data!);
        emit(CreateSignalementSuccess());
      } catch (e) {
        emit(CreateSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<GetSignalementsEvent>((event, emit) async {
      emit(GetSignalementsLoading());
      try {
        ApiResponse<List<SignalementModel>> response =
            await signalementService.getSignalements();

        if (response.status == Status.error) {
          emit(GetSignalementsError(response.message));
          return;
        }

        signalements = response.data;
        emit(GetSignalementsSuccess());
      } catch (e) {
        emit(GetSignalementsError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<GetSignalementEvent>((event, emit) async {
      emit(GetSignalementLoading());
      try {
        ApiResponse<SignalementModel> response =
            await signalementService.getSignalement(event.id);

        if (response.status == Status.error) {
          emit(GetSignalementError(response.message));
          return;
        }

        emit(GetSignalementSuccess());
      } catch (e) {
        emit(GetSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<GetUsersSignalementsEvent>((event, emit) async {
      emit(GetUsersSignalementsLoading());
      try {
        ApiResponse<List<SignalementModel>> response =
            await signalementService.getUserSignalements();

        if (response.status == Status.error) {
          emit(GetUsersSignalementsError(response.message));
          return;
        }

        signalements = response.data;
        emit(GetUsersSignalementsSuccess());
      } catch (e) {
        emit(GetUsersSignalementsError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<UpdateSignalementEvent>((event, emit) async {
      emit(UpdateSignalementLoading());
      try {
        ApiResponse<SignalementModel> response =
            await signalementService.updateSignalement(
          event.id,
          event.coordinates,
          event.selectedDangerItems,
        );

        if (response.status == Status.error) {
          emit(UpdateSignalementError(response.message));
          return;
        }

        emit(UpdateSignalementSuccess());
      } catch (e) {
        emit(UpdateSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<DeleteSignalementEvent>((event, emit) async {
      emit(DeleteSignalementLoading());
      try {
        ApiResponse response =
            await signalementService.deleteSignalement(event.id);

        if (response.status == Status.error) {
          emit(DeleteSignalementError(response.message));
          return;
        }

        signalements!.removeWhere((element) => element.id == event.id);
        emit(DeleteSignalementSuccess());
      } catch (e) {
        emit(DeleteSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<UpVoteSignalementEvent>((event, emit) async {
      emit(UpVoteSignalementLoading());
      try {
        ApiResponse<SignalementUpVoteResponse> response =
            await signalementService.upVoteSignalement(event.id);

        if (response.status == Status.error) {
          emit(UpVoteSignalementError(response.message));
          return;
        }

        signalements!.firstWhere((element) => element.id == event.id).upVote =
            response.data!.upVote;
        signalements!.firstWhere((element) => element.id == event.id).userVotedList.add(event.userId);
        emit(UpVoteSignalementSuccess());
      } catch (e) {
        emit(UpVoteSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
    on<DownVoteSignalementEvent>((event, emit) async {
      emit(DownVoteSignalementLoading());
      try {
        ApiResponse<SignalementDownVoteResponse> response =
            await signalementService.downVoteSignalement(event.id);

        if (response.status == Status.error) {
          emit(DownVoteSignalementError(response.message));
          return;
        }

        signalements!.firstWhere((element) => element.id == event.id).downVote =
            response.data!.downVote;
        signalements!.firstWhere((element) => element.id == event.id).userVotedList.add(event.userId);
        emit(DownVoteSignalementSuccess());
      } catch (e) {
        emit(DownVoteSignalementError(
            "Une erreur s'est produite, veuillez réessayer."));
        throw Exception(e);
      }
    });
  }
}
