import 'package:diplom_app/models/FormSchema.dart';

class FormModel {
  FormModel({this.id, this.name, this.schema});
  String id;
  String name;
  List<FormSchema> schema;

  FormModel.fromJSON(Map<String, dynamic> data)
      : this.id = data['_id'],
        this.name = data['name'],
        this.schema = List<FormSchema>.from(
            data['schema'].map((x) => FormSchema.fromJSON(x)));
}
