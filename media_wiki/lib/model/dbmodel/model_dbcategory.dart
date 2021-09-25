
// Category table name
const String tableCategory = 'category';

// This class defines category table fields
class CategoryFields {
  static const String id = '_id';
  static const String categoryName = 'catname';

  static final List<String> values = [id, categoryName];
}

// Model class for category table
class Category {
  final int? id;
  final String catname;

  Category({this.id, required this.catname});

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.categoryName: catname,
      };

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        catname: json[CategoryFields.categoryName] as String,
      );

  Category copy({int? id}) => Category(id: id ?? this.id, catname: catname);
}
