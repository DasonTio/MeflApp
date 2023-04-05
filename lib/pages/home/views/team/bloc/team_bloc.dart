import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';
import 'package:mefl_app_bloc/repository/team_repo.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc() : super(TeamState()) {
    on<JoinTeamButtonEvent>(_handleJoinTeamEvent);
    on<CreateTeamButtonEvent>(_handleCreateTeamEvent);
    on<ChangeTeamCodeEvent>(_handleChangeTeamCodeEvent);
    on<ChangeTeamStatusEvent>(_handleChangeTeamStatusEvent);
    on<AcceptMemberButtonEvent>(_handleAcceptMemberEvent);
    on<RejectMemberButtonEvent>(_handleRejectMemberEvent);

    on<ChangeToSingleViewButtonEvent>(_handleChangeToSingleViewButtonEvent);
    on<ChangeToManyViewButtonEvent>(_handleChangeToManyViewButtonEvent);
  }

  UserRepo _user = UserRepo();
  TeamRepo _repo = TeamRepo();

  Future<void> _handleJoinTeamEvent(
    JoinTeamButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      _repo.requestJoin(teamCode: state.teamCode);
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }

  Future<void> _handleCreateTeamEvent(
    CreateTeamButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      _repo.create();
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }

  Future<void> _handleChangeTeamCodeEvent(
    ChangeTeamCodeEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(teamCode: event.teamCode));
  }

  Future<void> _handleChangeTeamStatusEvent(
    ChangeTeamStatusEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(teamStatus: event.teamStatus));
  }

  Future<void> _handleAcceptMemberEvent(
    AcceptMemberButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      _repo.acceptJoin(requestedUserId: event.userId);
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }

  Future<void> _handleRejectMemberEvent(
    RejectMemberButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      _repo.rejectJoin(requestedUserId: event.userId);
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }

  Future<void> _handleChangeToManyViewButtonEvent(
    ChangeToManyViewButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      UserModel user = await _user.me();
      await _user.update(user: user.copyWith(teamId: event.teamId));
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }

  Future<void> _handleChangeToSingleViewButtonEvent(
    ChangeToSingleViewButtonEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      UserModel user = await _user.me();
      await _user.update(user: user.copyWith(teamId: ""));
      emit(state.copyWith(teamStatus: TeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: TeamStatus.failure));
    }
  }
}
