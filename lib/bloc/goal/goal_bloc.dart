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
      emit(GoalLoaded(goal: goals));
    });

    on<AddGoal>((event, emit) async {
      await GoalDAO.insertGoal(event.goal);
      if(state is GoalLoaded){
        final state = this.state as GoalLoaded;
        emit(GoalLoaded(goal: List.from(state.goal)..add(event.goal)));
      }
    });

    on<UpdateGoal>((event, emit) async {
      await GoalDAO.updateGoal(event.goal);
      if(state is GoalLoaded){
        final state = this.state as GoalLoaded;
        emit(GoalLoaded(goal: List.from(state.goal)));
      }
    });

    on<DeleteGoal>((event, emit) async {
      await GoalDAO.deleteGoal(event.goal);
      if(state is GoalLoaded){
        final state = this.state as GoalLoaded;
        emit(GoalLoaded(goal: List.from(state.goal)..remove(event.goal)));
      }
    });
  }
}