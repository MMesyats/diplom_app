import 'dart:io';

import 'package:diplom_app/common/CommonScaffold.dart';
import 'package:diplom_app/models/FormSchema.dart';
import 'package:diplom_app/models/Note.dart';
import 'package:diplom_app/models/NoteModel.dart';
import 'package:diplom_app/notes/SendButton.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormGenerator extends StatefulWidget {
  final NoteModel noteModel;
  final String userId;
  final bool update;
  FormGenerator({this.noteModel, this.userId = null, this.update = false});
  @override
  _FormGeneratorState createState() => _FormGeneratorState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _FormGeneratorState extends State<FormGenerator> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _fieldPadding = const EdgeInsets.symmetric(vertical: 20);
  static const _hintStyle = const TextStyle(
    color: Color(0xFF8D8D8D),
    fontSize: 16,
  );
  String _fileLabel;
  File _image;
  List<FormSchema> _formSchema = [];
  Set<String> _tags = {};
  Map<String, dynamic> _controllers = {};

  void initSchema() {
    widget.noteModel.form.schema.forEach((e) {
      _formSchema
          .add(FormSchema(label: e.label, options: e.options, type: e.type));
    });
  }

  void initControllers() {
    _formSchema.forEach((e) {
      switch (e.type) {
        case 'select':
          String value = widget.noteModel.note != null
              ? widget.noteModel.note.fields
                  .firstWhere((element) => element.label == e.label)
                  .value
              : null;
          setState(() {
            _controllers.putIfAbsent(e.label, () => value);
          });
          break;
        case 'image':
          setState(() {
            _fileLabel = e.label;
          });
          break;
        default:
          TextEditingController controller = TextEditingController(
              text: widget.noteModel.note != null
                  ? widget.noteModel.note.fields
                      .firstWhere((element) => element.label == e.label)
                      .value
                  : '');
          setState(() {
            _controllers.putIfAbsent(e.label, () => controller);
          });
      }
    });
  }

  DateTime selectedDate = DateTime.now();
  _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void tagsListener() {
    if (_tagsController.text.endsWith(' ')) {
      String tagText = _tagsController.text;

      setState(() {
        _tags.add(tagText.trim());
      });
      _tagsController.clear();
    }
  }

  void _sendData() async {
    await Backend.createNote(
        Note(
            date: selectedDate,
            form: widget.noteModel.form.id,
            name: _nameController.text,
            tags: _tags,
            fields: _controllers.entries
                .map((e) => Field(
                    label: e.key,
                    value: e.value is TextEditingController
                        ? e.value.text
                        : e.value))
                .toList()),
        _image,
        _fileLabel,
        id: widget.userId);
    Navigator.of(context)..pop()..pop();
  }

  void _updateData() async {
    await Backend.updateNote(
        Note(
            id: widget.noteModel.note.id,
            date: selectedDate,
            form: widget.noteModel.form.id,
            name: _nameController.text,
            tags: _tags,
            fields: _controllers.entries
                .map((e) => Field(
                    label: e.key,
                    value: e.value is TextEditingController
                        ? e.value.text
                        : e.value))
                .toList()),
        _image,
        _fileLabel,
        id: widget.userId);
    Navigator.of(context).pop();
  }

  _putField(int index) {
    switch (_formSchema[index].type) {
      case 'select':
        return DropdownButton(
            hint: Text(_formSchema[index].label),
            onChanged: (newValue) {
              setState(() {
                _controllers[_formSchema[index].label] = newValue;
              });
            },
            value: _controllers[_formSchema[index].label],
            items: _formSchema[index]
                .options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList());
        break;
      case 'image':
        final picker = ImagePicker();
        Future getImage() async {
          final pickedFile = await picker.getImage(source: ImageSource.gallery);

          setState(() {
            if (pickedFile != null) {
              _image = File(pickedFile.path);
            } else {
              print('No image selected.');
            }
          });
        }

        return Column(
          children: [
            TextButton(onPressed: getImage, child: Text('Картинка')),
            _image != null
                ? Image.file(_image)
                : widget.noteModel.note != null
                    ? widget.noteModel.note.fields
                                .firstWhere((element) =>
                                    element.label == _formSchema[index].label)
                                .value !=
                            null
                        ? Image.network(
                            'http://192.168.0.134:4000/${widget.noteModel.note.fields.firstWhere((element) => element.label == _formSchema[index].label).value}')
                        : SizedBox()
                    : SizedBox()
          ],
        );
        break;
      default:
        return TextFormField(
            controller: _controllers[_formSchema[index].label],
            keyboardType: _formSchema[index].type == 'number'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: _formSchema[index].label,
              hintStyle: _hintStyle,
            ));
    }
  }

  @override
  void initState() {
    if (widget.noteModel.note != null) {
      _tags.addAll(widget.noteModel.note.tags);
    }
    widget.noteModel.note != null
        ? _nameController.text = widget.noteModel.note.name
        : _nameController.text = widget.noteModel.form.name;

    initSchema();
    initControllers();

    _tagsController.addListener(tagsListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: widget.noteModel.note != null
          ? widget.noteModel.note.name
          : widget.noteModel.form.name,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: _fieldPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Название формы', hintStyle: _hintStyle),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.noteModel.form.schema.length,
                    itemBuilder: (context, index) => Padding(
                        padding: _fieldPadding, child: _putField(index))),
                Padding(
                  padding: _fieldPadding,
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _dateController
                      ..text =
                          '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                    onTap: _selectDate,
                    decoration: InputDecoration(hintText: 'Дата'),
                  ),
                ),
                Padding(
                  padding: _fieldPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _tagsController,
                    decoration: InputDecoration(
                        hintText: 'Теги', hintStyle: _hintStyle),
                  ),
                ),
                Padding(
                  padding: _fieldPadding,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      _tags.length,
                      (index) => ActionChip(
                        padding: EdgeInsets.all(10),
                        label: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(_tags.elementAt(index)),
                              Icon(
                                Icons.close,
                                size: 20,
                              ),
                            ]),
                        onPressed: () {
                          setState(() {
                            _tags.remove(_tags.elementAt(index));
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SendButton(
                  title: widget.update ? 'Обновить' : 'Зберегти',
                  onPressed: widget.update ? _updateData : _sendData,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
