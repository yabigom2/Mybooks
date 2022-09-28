import 'dart:convert';
import 'dart:math';
import 'package:book/database/databaseManager.dart';
import 'package:book/model/bookData.dart';
import 'package:book/ui/bookEdit.dart';
import 'package:book/ui/bookInsert.dart';
import 'package:book/ui/bookSearch.dart';
import 'package:book/ui/expanableFab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';


void main() {
  runApp(const MyBookApp());
}

class MyBookApp extends StatelessWidget {
  const MyBookApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF9AEFDD),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/search': (context) => BookSearchApp(),
        '/add': (context) => BookInsertApp(BookData())
      },
      home: BookListApp(),
    );
  }
}

class BookListApp extends StatefulWidget {
  @override
  State<BookListApp> createState() => _BookListState();
}

class _BookListState extends State<BookListApp> {

  static const platform = const MethodChannel('com.yabigom.book.book/userInfo');

  Future<List<BookData>>? bookList;

  static const _actionTitles = [
    '이 책 많이 읽고!~\n똑똑박사 되렴!~',
    '이 사랑해!~\n알러뷰 뿅뿅!~',
    '이 이번주에 자전거타러갈래?~\n상암까지 다녀오자!~',
    '아! 넌 뭐든지 잘 할 수 있어!\n자신감을 갖고 화이팅!!',
    '이 밥 편식하지 말고 골고루 먹어~\n그래야 튼튼해 진다!~',
    '아! TV만 보지말고 책 많이 읽어!\n아빠가 지켜볼거야! ㅡㅡ^',


  ];

  String userName = "";

  @override
  void initState() {
    _getUserInfo();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAction(BuildContext context, String contents) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('아빠의 알림'),
          content: Text(contents),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getUserInfo() async {
    try {
      final String result = await platform.invokeMethod('getUserInfo');
      userName = result;
    } on PlatformException catch (e) {
      userName = 'Unknown';
    }

    DatabaseManager().setUser(userName);

    setState(() {
      bookList = DatabaseManager().getBookList();
    });
  }

  void onBarcodeScan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    if (barcodeScanRes.isNotEmpty) {
      if (barcodeScanRes.compareTo("-1") != 0) {
        // TODO 스캔 완료 후 등록 페이지로 이동
        requestGetBookData(barcodeScanRes);
      }
    } else {
      _showAction(context, "바코드 정보가 없습니다.");
    }
  }

  void requestGetBookData(String isbn) async {
    var url = 'https://dapi.kakao.com/v3/search/book?target=isbn&query=' + isbn;
    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK 0327f22e3dc390bb643bbef740267806"});

    var converted = json.decode(response.body);
    final parsed = converted['documents'].cast<Map<String, dynamic>>();
    List<BookData> bookdata = parsed.map<BookData>((json) => BookData.fromJson(json)).toList();
    if(bookdata.isNotEmpty) {
      moveAdd(bookdata[0]);
    }
  }

  moveAdd(BookData bookData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookInsertApp(bookData),
      ),
    );

    if (result) {
      bookList = DatabaseManager().getBookList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName.compareTo("") > 0 ? '$userName이의 꿈 도서관' : "",),

        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookSearchApp()),
              );

              if (result) {
                bookList = DatabaseManager().getBookList();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    int size = (snapshot.data as List<BookData>).length;
                    return Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          // wrap your Column in Expanded
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4,
                              child: Container(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 20.0, 0),
                                    child: Text(
                                      "총 " + '$size' + "권",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // row count
                            childAspectRatio: 1 / 1.77, // 아이템의 가로세로 비율
                            mainAxisSpacing: 5, // 수평 패딩
                            crossAxisSpacing: 5, // 수직 패딩
                          ),
                          itemBuilder: (context, index) {
                            BookData bookData =
                                (snapshot.data as List<BookData>)[index];
                            return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('알림'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  '[${bookData.title}] 을 삭제하시겠습니까?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              DatabaseManager()
                                                  .deleteBook(bookData);
                                              Navigator.of(context).pop();

                                              bookList = DatabaseManager()
                                                  .getBookList();
                                              setState(() {});
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BookEditApp(bookData)),
                                  );

                                  if (result) {
                                    bookList = DatabaseManager().getBookList();
                                    setState(() {});
                                  }

                                  // SnackBar 노출
                                  Scaffold.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        content: Text(result
                                            ? "수정 되었습니다."
                                            : "취소 되었습니다.")));
                                },
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: bookData.thumbnail?.toString() ?? "",
                                        fit: BoxFit.contain,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/launch.jpg', fit: BoxFit.contain);
                                        },
                                      ),
                                      Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        color: Colors.white,
                                        child: Text(
                                          bookData.title!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          itemCount: (snapshot.data as List<BookData>).length,
                        ),
                      )
                    ]);
                  } else {
                    return Text('No Data');
                  }
              }
            },
            future: bookList,
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        children: [
          ActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookInsertApp(BookData())),
              );

              if (result) {
                bookList = DatabaseManager().getBookList();
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () => onBarcodeScan(),
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          ActionButton(
            onPressed: () =>
                _showAction(context, userName + _actionTitles[Random().nextInt(_actionTitles.length)]),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
