class PersonalAccount {
  final int id;
  final int identifier;
  final String iin;
  final String owner;
  final String city;
  final String birthday;
  final String? homePhone1;
  final String? homePhone2;

  PersonalAccount({
    required this.id,
    required this.identifier,
    required this.iin,
    required this.owner,
    required this.city,
    required this.birthday,
    required this.homePhone1,
    required this.homePhone2,
  });

  factory PersonalAccount.fromJson(Map<String, dynamic> json) {
    return PersonalAccount(
      id: json['id'],
      identifier: json['identifier'],
      iin: json['iin'],
      owner: json['owner'],
      city: json['city'],
      birthday: json['birthday'],
      homePhone1: json['home_phone_1'],
      homePhone2: json['home_phone_2'],
    );
  }
}
