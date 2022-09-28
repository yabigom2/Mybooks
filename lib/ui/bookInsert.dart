import 'package:book/database/databaseManager.dart';
import 'package:book/model/bookData.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BookInsertApp extends StatefulWidget {
  BookData bookData;

  BookInsertApp(this.bookData);

  @override
  State<BookInsertApp> createState() => _BookInsertState();
}

class _BookInsertState extends State<BookInsertApp> {
  final _bookNameController = TextEditingController();
  final _bookCompanyController = TextEditingController();
  final _bookWriterController = TextEditingController();
  final _bookDateController = TextEditingController();
  final _bookIsbnController = TextEditingController();
  final _bookDetailController = TextEditingController();
  final _bookPriceController = TextEditingController();
  final _bookBuyDateController = TextEditingController();

  @override
  void initState() {
    if (widget.bookData != null) {
      setState(() {});
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    _bookCompanyController.dispose();
    _bookWriterController.dispose();
    _bookDateController.dispose();
    _bookIsbnController.dispose();
    _bookDetailController.dispose();
    _bookPriceController.dispose();
    _bookBuyDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('도서등록'),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.bookData.thumbnail?.toString() ?? "",
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
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _bookNameController
                            ..text = widget.bookData.title ?? "",
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return '도서명을 입력하세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '도서명'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _bookCompanyController
                            ..text = widget.bookData.publisher ?? "",
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return '출판사를 입력하세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '출판사'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _bookWriterController
                            ..text = widget.bookData.authors ?? "",
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return '책 저자를 입력하세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '저자'),
                        ),
                      ),
                    ]),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookDateController
                      ..text = widget.bookData.datetime ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return '책 출판일을 입력하세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '출판일'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookIsbnController
                      ..text = widget.bookData.isbn ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'ISBN을 입력하세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'ISBN'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookDetailController
                      ..text = widget.bookData.contents ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return '책 소개정보를 입력하세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '도서소개'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookPriceController
                      ..text = widget.bookData.price?.toString() ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return '책 가격을 입력하세요';
                      }
                      return '';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '가격'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookBuyDateController
                      ..text = widget.bookData.buyDate ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return '책 구입일을 입력하세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '구입일'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            child: Text('저장'),
                            onPressed: () {

                              if(_bookNameController.value.text.isEmpty || _bookCompanyController.value.text.isEmpty || _bookWriterController.value.text.isEmpty) {
                                return;
                              }

                              // DB에 데이터 저장
                              DatabaseManager().insertBook(BookData(
                                  thumbnail: widget.bookData.thumbnail,
                                  title: _bookNameController.value.text,
                                  publisher: _bookCompanyController.value.text,
                                  authors: _bookWriterController.value.text,
                                  datetime: _bookDateController.value.text,
                                  isbn: _bookIsbnController.value.text,
                                  contents: _bookDetailController.value.text,
                                  price: _bookPriceController.value.text.isNotEmpty ? int.parse(_bookPriceController.value.text) : null,
                                  buyDate: _bookBuyDateController.value.text));
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 50),
                              primary: Colors.green,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 50),
                              primary: Colors.lightGreen,
                            )),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
