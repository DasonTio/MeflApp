part of 'team_bloc.dart';

enum TeamStatus {
  loading,
  success,
  failure,
}

class TeamState extends Equatable {
  const TeamState({
    this.teamCode = '',
    this.teamStatus = TeamStatus.loading,
  });
  final String teamCode;
  final TeamStatus teamStatus;

  TeamState copyWith({
    String? teamCode,
    TeamStatus? teamStatus,
  }) {
    return TeamState(
      teamCode: teamCode ?? this.teamCode,
      teamStatus: teamStatus ?? this.teamStatus,
    );
  }

  @override
  List<Object> get props => [
        teamCode,
        teamStatus,
      ];
}
