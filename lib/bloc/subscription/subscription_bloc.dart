import 'package:bloc/bloc.dart';
import 'package:expense_tracker/database/subscription_dao.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:equatable/equatable.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    List<Subscription> subscriptions = [];

    on<GetSubscriptions>((event, emit) async {
      subscriptions = await SubscriptionDAO.getSubscriptions();
      emit(SubscriptionLoaded(subscription: subscriptions, lastUpdated: DateTime.now()));
    });

    on<AddSubscription>((event, emit) async {
      final insertedId = await SubscriptionDAO.insertSubscription(event.subscription);
      final updatedSubscription = event.subscription.copyWith(id: insertedId);
      if (state is SubscriptionLoaded) {
        final currentState = state as SubscriptionLoaded;
        final updatedSubscriptions = List<Subscription>.from(currentState.subscription)..add(updatedSubscription);
        emit(SubscriptionUpdated(updatedSubscriptions: updatedSubscriptions, lastUpdated: DateTime.now()));
      }
    });

    on<UpdateSubscription>((event, emit) async {
      await SubscriptionDAO.updateSubscription(event.subscription);
      if (state is SubscriptionLoaded) {
        final currentState = state as SubscriptionLoaded;
        final updatedSubscriptions = currentState.subscription.map((subscription) {
          return subscription.id == event.subscription.id ? event.subscription : subscription;
        }).toList();
        emit(SubscriptionUpdated(updatedSubscriptions: updatedSubscriptions, lastUpdated: DateTime.now()));
      }
    });

    on<DeleteSubscription>((event, emit) async {
      await SubscriptionDAO.deleteSubscription(event.subscription);
      if (state is SubscriptionLoaded) {
        final currentState = state as SubscriptionLoaded;
        final updatedSubscriptions =
            currentState.subscription.where((subscription) => subscription.id != event.subscription.id).toList();
        emit(SubscriptionUpdated(updatedSubscriptions: updatedSubscriptions, lastUpdated: DateTime.now()));
      }
    });
  }
}
