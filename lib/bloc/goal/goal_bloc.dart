import 'package:bloc/bloc.dart';
import 'package:expense_tracker/database/goal_dao.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:equatable/equatable.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalInitial()) {
    List<Goal> goals = [];

    on<GetGoals>((event, emit) async {
      goals = await GoalDAO.getGoals();
      emit(GoalLoaded(goal: goals, lastUpdated: DateTime.now()));
    });

    on<AddGoal>((event, emit) async {
      final insertedId = await GoalDAO.insertGoal(event.goal);
      final updatedGoal = event.goal.copyWith(id: insertedId);
      if (state is GoalLoaded) {
        final currentState = state as GoalLoaded;
        final updatedGoals = List<Goal>.from(currentState.goal)..add(updatedGoal);
        emit(GoalUpdated(updatedGoals: updatedGoals, lastUpdated: DateTime.now()));
      }
    });

    on<UpdateGoal>((event, emit) async {
      await GoalDAO.updateGoal(event.goal);
      if (state is GoalLoaded) {
        final currentState = state as GoalLoaded;
        final updatedGoals = currentState.goal.map((goal) {
          return goal.id == event.goal.id ? event.goal : goal;
        }).toList();
        emit(GoalUpdated(updatedGoals: updatedGoals, lastUpdated: DateTime.now()));
      }
    });

    on<DeleteGoal>((event, emit) async {
      await GoalDAO.deleteGoal(event.goal);
      if (state is GoalLoaded) {
        final currentState = state as GoalLoaded;
        final updatedGoals = currentState.goal.where((goal) => goal.id != event.goal.id).toList();
        emit(GoalUpdated(updatedGoals: updatedGoals, lastUpdated: DateTime.now()));
      }
    });
  }
}
