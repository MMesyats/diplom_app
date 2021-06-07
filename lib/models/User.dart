class User {
  User(
      {this.name,
      this.surname,
      this.lastname,
      this.city,
      this.birthdayDate,
      this.bloodType,
      this.height,
      this.weight});

  String id;
  String name;
  String surname;
  String lastname;
  String city;
  String bloodType;
  DateTime birthdayDate;
  num height;
  num weight;
  bool isDoctor;

  User.fromJson(Map<String, dynamic> data)
      : this.name = data['name'],
        this.surname = data['surname'],
        this.lastname = data['lastname'],
        this.city = data['city'],
        this.birthdayDate = DateTime.parse(data['birthdayDate']),
        this.bloodType = data['bloodType'],
        this.height = data['height'],
        this.weight = data['weight'],
        this.id = data['_id'];

  Map<String, dynamic> toJson() => ({
        "name": this.name,
        "surname": this.surname,
        "lastname": this.lastname,
        "city": this.city,
        "birthdayDate": this.birthdayDate.toIso8601String() + "Z",
        "bloodType": this.bloodType,
        "height": this.height,
        "weight": this.weight,
        if (this.id != null) "_id": this.id
      });
}
