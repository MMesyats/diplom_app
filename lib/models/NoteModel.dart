import 'package:diplom_app/models/Form.dart';
import 'package:diplom_app/models/Note.dart';

class NoteModel {
  NoteModel({this.note, this.form});
  Note note;
  FormModel form;

  NoteModel.fromJson(Map<String, dynamic> data)
      : this.note = Note.fromJson(data['note']),
        this.form = FormModel.fromJSON(data['form']);
}
