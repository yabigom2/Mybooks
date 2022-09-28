import 'package:book/model/bookData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database Manager (Singleton)
class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;

  static const String table_booklist = "BookList";
  late Future<Database> db;

  late String userName;

  DatabaseManager._internal() {
    db = initDatabase();
  }

  // Database 생성
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'book_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "Create TABLE BookList(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "thumbnail TEXT, title TEXT, publisher TEXT, authors TEXT, datetime TEXT, isbn TEXT, contents TEXT, price INTEGER, buyDate TEXT, userName TEXT)",
        );
      },
      version: 1,
    );
  }

  void setUser(String name) {
    userName = name;
  }

  // 책 정보를 Database에 Insert
  void insertBook(BookData book) async {
    book.userName = userName;
    final Database database = await db;
    int result = await database.insert(
        table_booklist,
        book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("insertBook : " + result.toString());
  }

  // 책 정보를 Database에 Update
  void updateBook(BookData book) async {
    book.userName = userName;
    final Database database = await db;
    await database.update(
      table_booklist,
      book.toMap(),
      where: 'id = ? ',
      whereArgs: [book.id],
    );
  }

  // 책 정보를 Database에서 Delete
  void deleteBook(BookData book) async {
    final Database database = await db;
    await database.delete(
      table_booklist,
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // 해당 ID에 매핑되는 책 정보 가져오기
  Future<List<BookData>> getBookData(int id) async {
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.rawQuery(
        'select * from BookList where id = ?', ['%$id%']);

    return List.generate(maps.length, (i) {
      return BookData(
          id: maps[i]['id'],
          thumbnail: maps[i]['thumbnail'].toString(),
          title: maps[i]['title'].toString(),
          publisher: maps[i]['publisher'].toString(),
          authors: maps[i]['authors'].toString(),
          datetime: maps[i]['datetime'].toString(),
          isbn: maps[i]['isbn'].toString(),
          contents: maps[i]['contents'].toString(),
          price: maps[i]['price'],
          buyDate: maps[i]['buyDate'].toString(),
          userName: maps[i]['userName'].toString(),
      );
    });
  }


  // 키워드로 책정보 가져오기 (like 검색)
  Future<List<BookData>> getSearchBook(String keyword) async {

    print("getSearchBook() : " + userName + " / " + keyword);

    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.rawQuery(
        "select id, thumbnail, title, publisher, authors, datetime, isbn, contents, price, buyDate, userName from BookList where userName like '%$userName%' AND (title like '%$keyword%' OR authors like '%$keyword%' OR isbn like '%$keyword%')");

    return List.generate(maps.length, (i) {
      return BookData(
          id: maps[i]['id'],
          thumbnail: maps[i]['thumbnail'].toString(),
          title: maps[i]['title'].toString(),
          publisher: maps[i]['publisher'].toString(),
          authors: maps[i]['authors'].toString(),
          datetime: maps[i]['datetime'].toString(),
          isbn: maps[i]['isbn'].toString(),
          contents: maps[i]['contents'].toString(),
          price: maps[i]['price'],
          buyDate: maps[i]['buyDate'].toString(),
          userName: maps[i]['userName'].toString(),
      );
    });
  }

  //책 전체 정보 가져오기
  Future<List<BookData>> getBookList() async {
    print("getBookList() : " + userName);

    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.rawQuery(
        "select id, thumbnail, title, publisher, authors, datetime, isbn, contents, price, buyDate, userName from BookList where userName like '%$userName%'");

    return List.generate(maps.length, (i) {
      return BookData(
          id: maps[i]['id'],
          thumbnail: maps[i]['thumbnail'].toString(),
          title: maps[i]['title'].toString(),
          publisher: maps[i]['publisher'].toString(),
          authors: maps[i]['authors'].toString(),
          datetime: maps[i]['datetime'].toString(),
          isbn: maps[i]['isbn'].toString(),
          contents: maps[i]['contents'].toString(),
          price: maps[i]['price'],
          buyDate: maps[i]['buyDate'].toString(),
          userName: maps[i]['userName'].toString(),
      );
    });
  }
}
