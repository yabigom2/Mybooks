import 'package:book/database/databaseManager.dart';
import 'package:book/model/bookData.dart';
import 'package:book/ui/bookEdit.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BookSearchApp extends StatefulWidget {
  @override
  State<BookSearchApp> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearchApp> {
  final _bookSearchController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  Future<List<BookData>>? bookList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bookList = DatabaseManager().getBookList();
  }

  @override
  void dispose() {
    _bookSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('도서검색'),
        ),
        body: Container(
          child: Center(
            child: Column(children: <Widget>[
              Form(
                key: _fromKey,
                child: Row(children: <Widget>[
                  Expanded(
                    // wrap your Column in Expanded
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _bookSearchController,
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return '도서명 또는 저자 정보를 입력해 주세요';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '도서명, 저자 검색'),
                      ),
                    ),
                  ),

                  // wrap your Column in Expanded
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        child: Text('검색'),
                        onPressed: () {
                          if (_fromKey.currentState!.validate()) {
                            bookList = DatabaseManager().getSearchBook(
                                _bookSearchController.text.toString());
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 50),
                          primary: Colors.green,
                        )),
                  ),
                ]),
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                BookData book =
                                    (snapshot.data as List<BookData>)[index];
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookEditApp(book)),
                                    );

                                    if (result) {
                                      setState(() {
                                        bookList =
                                            DatabaseManager().getBookList();
                                      });
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
                                    child: Row(
                                      children: <Widget>[
                                        FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: book.thumbnail?.toString() ?? "",
                                          width: 150,
                                          height: 200,
                                          fit: BoxFit.contain,
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/images/launch.jpg', fit: BoxFit.contain
                                              ,width: 150, height: 200,);
                                          },
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                child: Text(
                                                    book.title!,
                                                    textAlign:TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    150,
                                                child: Text(book.authors!.toString(), textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.grey
                                                  ),
                                                ),
                                              ),Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    150,
                                                child: Text(book.publisher!.toString(), textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontStyle: FontStyle.normal,
                                                      color: Colors.grey
                                                  ),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  (snapshot.data as List<BookData>).length,
                            ),
                          ),
                        );
                      } else {
                        return Text('No Data');
                      }
                  }
                },
                future: bookList,
              ),
            ]),
          ),
        ));
  }
}