class CategoryModel {
  final String id;
  final String categoryName;
  final String descreption;
  final String imgUrl;
  final int orderCount;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.imgUrl,
    required this.descreption,
    required this.orderCount,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'],
      categoryName: data['categoryName'],
      imgUrl: data['imgUrl'],
      descreption: data['descreption'],
      orderCount: data['orderCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'imgUrl': imgUrl,
      'descreption': descreption,
      'orderCount': orderCount,
    };
  }
}
