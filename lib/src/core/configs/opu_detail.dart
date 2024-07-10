class OpuDetail {
  final int id;
  final String? address;
  final String? comment;
  final double? conduit_size;
  final dynamic general_opu;
  final dynamic house;
  final bool? is_active;
  final bool? is_deleted;
  final dynamic journal;
  final dynamic locality;
  final dynamic location;
  final dynamic meters;
  final List<dynamic> node_amounts;
  final dynamic old_opu;
  final dynamic opu_actions;
  final dynamic opu_indications;
  final String? number;
  final int? personal_accounts_count;
  final dynamic stamp;
  final dynamic street;
  final int? user;

  OpuDetail({
    required this.id,
    this.address,
    this.comment,
    this.conduit_size,
    this.general_opu,
    this.house,
    this.is_active,
    this.is_deleted,
    this.journal,
    this.locality,
    this.location,
    this.street,
    this.user,
    this.meters,
    this.node_amounts = const [],
    this.old_opu,
    this.opu_actions,
    this.opu_indications,
    this.number,
    this.personal_accounts_count,
    this.stamp,
  });

  factory OpuDetail.fromJson(Map<String, dynamic> json) {
    return OpuDetail(
      id: json['id'],
      comment: json['comment'],
      house: json['house'],
      is_active: json['is_active'],
      is_deleted: json['is_deleted'],
      journal: json['journal'],
      locality: json['locality'],
      location: json['location'],
      street: json['street'],
      user: json['user'],
      meters: json['meters'],
      node_amounts: json['node_amounts'],
      old_opu: json['old_opu'],
      opu_actions: json['opu_actions'],
      opu_indications: json['opu_indications'],
      number: json['number'],
      personal_accounts_count: json['personal_accounts_count'],
      stamp: json['stamp'],
      conduit_size: json['conduit_size'],
      general_opu: json['general_opu'],
      address: json['address'],
    );
  }
}
