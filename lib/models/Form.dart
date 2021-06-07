class FormModel {
  FormModel(this.id, this.name, this.schema);
  String id;
  String name;
  List<dynamic> schema;

  FormModel.fromJSON(Map<String, dynamic> data)
      : id = data['_id'],
        name = data['name'],
        schema = data['schema'];
}
