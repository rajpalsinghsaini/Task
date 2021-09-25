import 'package:media_wiki/model/dbmodel/model_dbarticle.dart';
import 'package:media_wiki/model/dbmodel/model_dbcategory.dart';
import 'package:media_wiki/model/dbmodel/model_dbimages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// This class is used to store data in Sqflite database
class WikiDatabase {
  static final WikiDatabase instance = WikiDatabase._init();
  static Database? _database;

  WikiDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('wiki.db');
    return _database!;
  }

  // Initializing the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // This method created tables in database
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    // Creates DB for category
    await db.execute('''
      CREATE TABLE $tableCategory(
        ${CategoryFields.id} $idType,
        ${CategoryFields.categoryName} $textType
      )
    ''');

    // Creates db for article
    await db.execute('''
      CREATE TABLE $tableArticle(
        ${ArticleFields.id} $idType,
        ${ArticleFields.articleTitle} $textType,
        ${ArticleFields.articleDesc} $textType
      )
    ''');

    // Creates db for images
    await db.execute('''
      CREATE TABLE $tableImages(
        ${ImageFields.id} $idType,
        ${ImageFields.imageUrl} $textType
      )
    ''');
  }

  //==================================================== DB Methods for Category ========================================================================

  // Insert new category record in database
  Future<Category> createCategory(Category category) async {
    final db = await instance.database;
    final id = await db.insert(tableCategory, category.toJson());

    return category.copy(id: id);
  }

  // Read single category record from database
  Future<bool> readCategory(String categoryName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategory,
      columns: CategoryFields.values,
      where: '${CategoryFields.categoryName} =?',
      whereArgs: [categoryName],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Read all category records from database
  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;
    const orderBy = '${CategoryFields.id} ASC';

    final result = await db.query(tableCategory, orderBy: orderBy);

    return result.map((json) => Category.fromJson(json)).toList();
  }

  //============================================== DB Methods for Articles =======================================================================

  // Insert new article record in database
  Future<Article> createArticle(Article article) async {
    final db = await instance.database;
    final id = await db.insert(tableArticle, article.toJson());

    return article.copy(id: id);
  }

  // Read single article record from database
  Future<bool> readArticle(String articleTitle) async {
    final db = await instance.database;
    final maps = await db.query(
      tableArticle,
      columns: ArticleFields.values,
      where: '${ArticleFields.articleTitle} =?',
      whereArgs: [articleTitle],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Read all article records from database
  Future<List<Article>> readAllArticles() async {
    final db = await instance.database;
    final orderBy = '${ArticleFields.id} ASC';

    final result = await db.query(tableArticle, orderBy: orderBy);

    return result.map((json) => Article.fromJson(json)).toList();
  }

  //================================================= DB Methods for Images ====================================================================

  // Insert new image record in database
  Future<WImage> createImage(WImage image) async {
    final db = await instance.database;
    final id = await db.insert(tableImages, image.toJson());

    return image.copy(id: id);
  }

  // Read single image record from database
  Future<bool> readSingleImage(String imgUrl) async {
    final db = await instance.database;
    final maps = await db.query(
      tableImages,
      columns: ImageFields.values,
      where: '${ImageFields.imageUrl} =?',
      whereArgs: [imgUrl],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Read all images records from database
  Future<List<WImage>> readAllImages() async {
    final db = await instance.database;
    const orderBy = '${ImageFields.id} ASC';

    final result = await db.query(tableImages, orderBy: orderBy);

    return result.map((json) => WImage.fromJson(json)).toList();
  }

  //======================================================================================================================================

  // This method close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
