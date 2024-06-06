class UserFood {
  UserFood({
    required this.imgProfile,
    required this.name,
    required this.id,
    required this.email,
  });
  late final String imgProfile;
  late final String name;
  late final String id;
  late final String email;

  UserFood.fromJson(Map<String, dynamic> json) {
    imgProfile = json['img_profile'];
    name = json['name'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['img_profile'] = imgProfile;
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
