class FormSchema {
  String label;
  String type;
  List<dynamic> options;
  FormSchema({this.label, this.type, this.options});

  FormSchema.fromJSON(Map<String, dynamic> data)
      : label = data['label'],
        type = data['type'],
        options = data['options'];
}
