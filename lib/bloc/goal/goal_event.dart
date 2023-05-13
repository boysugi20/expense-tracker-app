part of 'goal_bloc.dart';


abstract class GoalEvent extends Equatable {
  const GoalEvent();
}

class GetGoals extends GoalEvent {
  const GetGoals();
  @override
  List<Object?> get props => [];
}

class AddGoal extends GoalEvent {
  final Goal goal;
  const AddGoal({required this.goal,});

  @override
  List<Object?> get props => [goal];
}

class UpdateGoal extends GoalEvent {
  final Goal goal;
  
  const UpdateGoal({required this.goal});
  
  @override
  List<Object?> get props => [goal];

  get index => null;
}

class DeleteGoal extends GoalEvent {
  final Goal goal;
  const DeleteGoal({required this.goal});
  
  @override
  List<Object?> get props => [goal];
}