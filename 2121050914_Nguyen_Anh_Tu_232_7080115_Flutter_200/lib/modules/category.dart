// ignore_for_file: public_member_api_docs, sort_constructors_first

class Category {
  late String id;
  late String name;
  late String imgCategory;
  Category({
    required this.id,
    required this.name,
    required this.imgCategory,
  });

  Category.fromJson(Map<String, dynamic> json) {
    imgCategory = json['img_category'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['img_category'] = imgCategory;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
