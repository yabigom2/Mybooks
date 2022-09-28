import 'package:book/database/databaseManager.dart';
import 'package:book/model/bookData.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BookEditApp extends StatefulWidget {
  BookData targetBookData;

  BookEditApp(this.targetBookData);

  @override
  State<BookEditApp> createState() => _BookEditState();
}

class _BookEditState extends State<BookEditApp> {
  final _bookNameController = TextEditingController();
  final _bookCompanyController = TextEditingController();
  final _bookWriterController = TextEditingController();
  final _bookDateController = TextEditingController();
  final _bookIsbnController = TextEditingController();
  final _bookDetailController = TextEditingController();
  final _bookPriceController = TextEditingController();
  final _bookBuyDateController = TextEditingController();

  // BookData? _targetBookData;

  @override
  void initState() {
    // DatabaseManager().getBookData(widget.id).then((value) {
    //    _targetBookData = value[0];
    //    setState(() {});
    // });

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
          title: Text('도서 정보 수정'),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.targetBookData.thumbnail?.toString() ?? "",
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
                            ..text = widget.targetBookData.title ?? "",
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
                            ..text = widget.targetBookData.publisher ?? "",
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
                            ..text = widget.targetBookData.authors ?? "",
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
                    controller: _bookDateController..text = widget.targetBookData.datetime??"",
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
                    controller: _bookIsbnController..text = widget.targetBookData.isbn??"",
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
                    controller: _bookDetailController..text = widget.targetBookData.contents??"",
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
                    controller: _bookPriceController..text = widget.targetBookData.price?.toString() ?? "",
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return '책 가격을 입력하세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '가격'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _bookBuyDateController..text = widget.targetBookData.buyDate??"",
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
                            child: Text('수정'),
                            onPressed: () {
                              // DB에 데이터 저장
                              DatabaseManager().updateBook(BookData(
                                  id: widget.targetBookData.id,
                                  thumbnail: widget.targetBookData.thumbnail,
                                  title: _bookNameController.value.text,
                                  publisher: _bookCompanyController.value.text,
                                  authors: _bookWriterController.value.text,
                                  datetime: _bookDateController.value.text,
                                  isbn: _bookIsbnController.value.text,
                                  contents: _bookDetailController.value.text,
                                  price: int.parse(_bookPriceController.value.text),
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
