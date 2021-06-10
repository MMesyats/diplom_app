import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  Note({
    this.name,
    this.tags,
    this.fields,
    this.form,
    this.date,
  });

  String id;
  String name;
  Set<String> tags;
  List<Field> fields;
  String form;
  DateTime date;

  Note.fromJson(Map<String, dynamic> json)
      : this.name = json["name"],
        this.tags = List<String>.from(json["tags"].map((x) => x)).toSet(),
        this.fields =
            List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
        this.form = json["form"],
        this.date = DateTime.parse(json['created_at']),
        this.id = json["_id"];

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "tags": Set<dynamic>.from(this.tags.map((x) => x)).toList(),
        "fields": List<dynamic>.from(this.fields.map((x) => x.toJson())),
        "form": this.form,
        "created_at": this.date.toIso8601String() + "Z",
        if (this.id != null) "_id": this.id
      };
}

class Field {
  Field({this.label, this.value});
  String label;
  dynamic value;

  Field.fromJson(Map<String, dynamic> json)
      : this.label = json['label'],
        this.value = json['value'];

  Map<String, dynamic> toJson() => {
        "label": this.label,
        "value": this.value,
      };
}
