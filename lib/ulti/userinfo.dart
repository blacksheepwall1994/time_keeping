// class UserInfo {
//   String? sid;
//   String? name;
//   String? cName;
//   DateTime? birth;
//   String? home;
//   String? phone;
//   DateTime? enter;
//   DateTime? leave;
//   bool? isLeave;

//   UserInfo();
// }
// {phone: 3, name: Bien, birth: 2022-12-14, adress: 2, id: 1, home: 1}
class UserInfo {
  String phone;
  String name;
  DateTime birth;
  String adress;
  String id;
  String home;

  UserInfo({
    required this.phone,
    required this.name,
    required this.birth,
    required this.adress,
    required this.id,
    required this.home,
  });

  factory UserInfo.fromJson(json) {
    return UserInfo(
      phone: json['phone'],
      name: json['name'],
      birth: DateTime.parse(json['birth']),
      adress: json['adress'],
      id: json['id'],
      home: json['home'],
    );
  }
}
