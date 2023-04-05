part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();
  @override
  List<Object?> get props => [];
}

class JoinTeamButtonEvent extends TeamEvent {
  const JoinTeamButtonEvent();
}

class CreateTeamButtonEvent extends TeamEvent {
  const CreateTeamButtonEvent();
}

class ChangeTeamCodeEvent extends TeamEvent {
  ChangeTeamCodeEvent({required this.teamCode});

  final String teamCode;
  @override
  List<Object?> get props => [teamCode];
}

class ChangeTeamStatusEvent extends TeamEvent {
  ChangeTeamStatusEvent({required this.teamStatus});
  final TeamStatus teamStatus;
  @override
  List<Object?> get props => [teamStatus];
}

class AcceptMemberButtonEvent extends TeamEvent {
  AcceptMemberButtonEvent({required this.userId});

  final String userId;
  @override
  List<Object?> get props => [userId];
}

class RejectMemberButtonEvent extends TeamEvent {
  RejectMemberButtonEvent({required this.userId});

  final String userId;
  @override
  List<Object?> get props => [userId];
}

class ChangeToSingleViewButtonEvent extends TeamEvent {
  ChangeToSingleViewButtonEvent();
}

class ChangeToManyViewButtonEvent extends TeamEvent {
  ChangeToManyViewButtonEvent({required this.teamId});

  final String teamId;
  @override
  List<Object?> get props => [teamId];
}
