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

  const GoalLoaded({required this.goal});
  @override
  List<Object> get props => [goal];
}