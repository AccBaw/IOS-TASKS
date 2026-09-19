class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(this.title, this.author, this.price, {this.isBorrowed = false});
}

class Library {
  List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) {
      return book.isBorrowed == false;
    }).toList();
  }

  List<Book> getBorrowedBooks() {
    return _books.where((book) {
      return book.isBorrowed == true;
    }).toList();
  }

  double getTotalValue() {
    return _books.fold(0.0, (total, book) {
      return total + book.price;
    });
  }
}

void main() {
  Library library = Library();

  library.addBook(
    Book("Don Quixote", "Miguel de Cervantes", 23.29),
  );

  library.addBook(
    Book(
      "Dune",
      "Frank Herbert",
      6.49,
      isBorrowed: true,
    ),
  );

  library.addBook(
    Book("1984", "George Orwell", 9.0),
  );

  library.addBook(
    Book(
      "The Hobbit",
      "J.R.R. Tolkien",
      25.0,
      isBorrowed: true,
    ),
  );

  List<Book> availableBooks = library.getAvailableBooks();

  print("Available books:");

  for (int i = 0; i < availableBooks.length; i++) {
    print(availableBooks[i].title);
  }

  List<Book> borrowedBooks = library.getBorrowedBooks();

  print("\nBorrowed books:");

  for (int i = 0; i < borrowedBooks.length; i++) {
    print(borrowedBooks[i].title);
  }

  double totalValue = library.getTotalValue();

  print("\nTotal collection value: $totalValue USD");
}