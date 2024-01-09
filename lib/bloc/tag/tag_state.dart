part of 'tag_bloc.dart';

abstract class TagState extends Equatable {
  const TagState();
}

class TagInitial extends TagState {
  @override
  List<Object> get props => [];
}

class TagLoaded extends TagState {
  final List<Tag> tag;
  final DateTime lastUpdated;

  const TagLoaded({required this.tag, required this.lastUpdated});

  @override
  List<Object> get props => [tag, lastUpdated];

  @override
  bool get stringify => true;
}
