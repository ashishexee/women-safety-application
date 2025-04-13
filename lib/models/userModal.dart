class Usermodal {
  String? name;
  String? phone;
  String? id;
  String? childEmail;
  String? parentsEmail;
  String? type;
  Usermodal({
    this.name,
    this.phone,
    this.id,
    this.childEmail,
    this.parentsEmail,
    this.type,
  });
  Map<String, dynamic> tojson() => {
    'name': name,
    'phone': phone,
    'id': id,
    'childEmail': childEmail,
    'parentEmail': parentsEmail,
    'type': type,
  };
}
