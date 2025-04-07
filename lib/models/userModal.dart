class Usermodal {
  String? name;
  String? phone;
  String? id;
  String? email;
  String? parentsEmail;
  String? type;
  Usermodal({this.name, this.phone, this.id, this.email, this.parentsEmail,this.type});
  Map<String, dynamic> tojson() => {
    'name': name,
    'phone': phone,
    'id': id,
    'email': email,
    'parentEmail': parentsEmail,
    'type': type,
  };
}
