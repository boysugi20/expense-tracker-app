part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();
}

class GetTags extends TagEvent {
  const GetTags();
  @override
  List<Object?> get props => [];
}

class AddTag extends TagEvent {
  final Tag tag;
  const AddTag({
    required this.tag,
  });
  @override
  List<Object?> get props => [tag];
}

class UpdateTag extends TagEvent {
  final Tag tag;
  const UpdateTag({required this.tag});
  @override
  List<Object?> get props => [tag];
  get index => null;
}

class DeleteTag extends TagEvent {
  final Tag tag;
  const DeleteTag({required this.tag});
  @override
  List<Object?> get props => [tag];
}
