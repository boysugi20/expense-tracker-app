part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
}

class SubscriptionInitial extends SubscriptionState {
  @override
  List<Object> get props => [];
}

class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> subscription;
  final DateTime lastUpdated;

  const SubscriptionLoaded({required this.subscription, required this.lastUpdated});

  @override
  List<Object> get props => [subscription, lastUpdated];

  @override
  bool get stringify => true;
}

class SubscriptionUpdated extends SubscriptionState {
  final List<Subscription> updatedSubscriptions;
  final DateTime lastUpdated;

  const SubscriptionUpdated({required this.updatedSubscriptions, required this.lastUpdated});

  @override
  List<Object> get props => [updatedSubscriptions, lastUpdated];

  @override
  bool get stringify => true;
}
