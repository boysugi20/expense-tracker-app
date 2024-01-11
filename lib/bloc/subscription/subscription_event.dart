part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
}

class GetSubscriptions extends SubscriptionEvent {
  const GetSubscriptions();
  @override
  List<Object?> get props => [];
}

class AddSubscription extends SubscriptionEvent {
  final Subscription subscription;
  const AddSubscription({
    required this.subscription,
  });
  @override
  List<Object?> get props => [subscription];
}

class UpdateSubscription extends SubscriptionEvent {
  final Subscription subscription;
  const UpdateSubscription({required this.subscription});
  @override
  List<Object?> get props => [subscription];
  get index => null;
}

class DeleteSubscription extends SubscriptionEvent {
  final Subscription subscription;
  const DeleteSubscription({required this.subscription});
  @override
  List<Object?> get props => [subscription];
}
