class BookData {
  int? id;
  String? thumbnail;
  String? title;
  String? publisher;
  String? authors;
  String? datetime;
  String? isbn;
  String? contents;
  int? price;
  String? buyDate;
  String? userName;

  BookData(
      {this.id, this.thumbnail, this.title, this.publisher, this.authors,
        this.datetime, this.isbn, this.contents, this.price, this.buyDate, this.userName});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'thumbnail' : thumbnail,
      'title' : title,
      'publisher' : publisher,
      'authors' : authors,
      'datetime' : datetime,
      'isbn' : isbn,
      'contents' : contents,
      'price' : price,
      'buyDate' : buyDate,
      'userName' : userName,
    };
  }

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      publisher: json['publisher'] as String,
      authors: json['authors'][0] as String,
      datetime: json['datetime'] as String,
      isbn: json['isbn'] as String,
      contents: json['contents'] as String,
      price: json['price'] as int,
      buyDate: "",
      userName: "",
    );
  }
}

