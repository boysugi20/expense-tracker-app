import 'package:expense_tracker/bloc/tag/tag_bloc.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../general/functions.dart';

class TagsForm extends StatefulWidget {
  final Tag? initialValues;
  final String header1, header2;

  const TagsForm(
      {required this.header1, this.header2 = '', this.initialValues, Key? key})
      : super(key: key);

  @override
  State<TagsForm> createState() => _TagsFormState();
}

class _TagsFormState extends State<TagsForm> {
  final _formKey = GlobalKey<FormState>();

  final TagBloc tagBloc = TagBloc();
  Tag tag = Tag(id: 0, name: '', color: '');

  Color currentColor = Colors.red;

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      tag = widget.initialValues!;
      currentColor = hexToColor(tag.color);
    } else {
      tag.color = colorToHex(currentColor);
    }
  }

  Future<void> insertTag() async {
    if (tag.name.isNotEmpty) {
      context.read<TagBloc>().add(AddTag(tag: tag));
    }
  }

  Future<void> updateTag() async {
    context.read<TagBloc>().add(UpdateTag(tag: tag));
  }

  Future<void> deleteTag() async {
    context.read<TagBloc>().add(DeleteTag(tag: tag));
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
        formKey: _formKey,
        header1: widget.header1,
        header2: widget.header2,
        buttonText: widget.initialValues == null ? null : '',
        onSave: () {
          widget.initialValues == null ? insertTag() : updateTag();
        },
        onDelete: () {
          deleteTag();
        },
        formInputs: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                FormTextInput(
                  title: 'Name',
                  labelText: 'Tag name',
                  isRequired: true,
                  initalText: tag.name,
                  onSave: (value) {
                    tag.name = value!;
                  },
                  validateText: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some value';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Choose color'),
                    content: MaterialColorPicker(
                        allowShades: false, // default true
                        onMainColorChange: (ColorSwatch? color) {
                          if (color != null) {
                            setState(() {
                              currentColor = color;
                            });
                            String hexCode = colorToHex(color);
                            tag.color = hexCode;
                          }
                        },
                        selectedColor: currentColor),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose color',
                  ),
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
