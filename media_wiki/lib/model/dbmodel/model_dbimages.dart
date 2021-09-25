// Category table name
const String tableImages = 'wimage';

// This class defines image table fields
class ImageFields {
  static const String id = '_id';
  static const String imageUrl = 'imgurl';

  static final List<String> values = [id, imageUrl];
}

// Model class for image table
class WImage {
  final int? id;
  final String imgurl;

  WImage({this.id, required this.imgurl});

  Map<String, Object?> toJson() => {
        ImageFields.id: id,
        ImageFields.imageUrl: imgurl,
      };

  static WImage fromJson(Map<String, Object?> json) => WImage(
        id: json[ImageFields.id] as int?,
        imgurl: json[ImageFields.imageUrl] as String,
      );

  WImage copy({int? id}) => WImage(id: id ?? this.id, imgurl: imgurl);
}
