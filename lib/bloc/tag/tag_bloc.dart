import 'package:bloc/bloc.dart';
import 'package:expense_tracker/database/tag_dao.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:equatable/equatable.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc() : super(TagInitial()) {
    List<Tag> tags = [];

    on<GetTags>((event, emit) async {
      tags = await TagDAO.getTags();
      emit(TagLoaded(tag: tags, lastUpdated: DateTime.now()));
    });

    on<AddTag>((event, emit) async {
      final insertedId = await TagDAO.insertTag(event.tag);
      final updatedTag = event.tag.copyWith(id: insertedId);
      if (state is TagLoaded) {
        final state = this.state as TagLoaded;
        emit(TagLoaded(
            tag: List.from(state.tag)..add(updatedTag),
            lastUpdated: DateTime.now()));
      }
    });

    on<UpdateTag>((event, emit) async {
      await TagDAO.updateTag(event.tag);
      if (state is TagLoaded) {
        final state = this.state as TagLoaded;
        emit(TagLoaded(tag: List.from(state.tag), lastUpdated: DateTime.now()));
      }
    });

    on<DeleteTag>((event, emit) async {
      await TagDAO.deleteTag(event.tag);
      if (state is TagLoaded) {
        final state = this.state as TagLoaded;
        emit(TagLoaded(
            tag: List.from(state.tag)..remove(event.tag),
            lastUpdated: DateTime.now()));
      }
    });
  }
}
