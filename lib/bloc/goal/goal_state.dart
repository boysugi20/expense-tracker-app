part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();
}

class GoalInitial extends GoalState {
  @override
  List<Object> get props => [];
}

class GoalLoaded extends GoalState {
  final List<Goal> goal;
  final DateTime lastUpdated;

  const GoalLoaded({required this.goal, required this.lastUpdated});

  @override
  List<Object> get props => [goal, lastUpdated];

  @override
  bool get stringify => true;
}