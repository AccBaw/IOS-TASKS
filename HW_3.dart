abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print("Downloading $title...");
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours = 0;
  String narrator = "";

  Audiobook(
    String id,
    String title,
    double price,
    double durationHours,
    String narrator,
  ) : super(id, title, price) {
    this.durationHours = durationHours;
    this.narrator = narrator;
  }

  @override
  String getDetails() {
    return "Audiobook: $title, Narrator: $narrator, Duration: $durationHours hours, Price: $price USD";
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB = 0;
  String author = "";

  EBook(
    String id,
    String title,
    double price,
    double fileSizeMB,
    String author,
  ) : super(id, title, price) {
    this.fileSizeMB = fileSizeMB;
    this.author = author;
  }

  @override
  String getDetails() {
    return "EBook: $title, Author: $author, File size: $fileSizeMB MB, Price: $price USD";
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double total = _items.fold(0.0, (total, item) {
      return total + item.price;
    });

    return total + total * taxRate;
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) {
      return item.price <= maxPrice;
    }).toList();
  }

  void printReceipt() {
    print("Shopping cart:");

    for (int i = 0; i < _items.length; i++) {
      print(_items[i].getDetails());

      if (_items[i] is Downloadable) {
        Downloadable item = _items[i] as Downloadable;
        item.download(_items[i].title);
      }
    }

    print("Total price with tax: ${calculateTotalWithTax()} USD");
  }
}

void main() {
  ShoppingCart cart = ShoppingCart();

  Audiobook book1 = Audiobook(
    "A01",
    "Harry Potter",
    23.29,
    8.5,
    "Stephen Fry",
  );

  EBook book2 = EBook(
    "E01",
    "1984",
    9.0,
    2.5,
    "George Orwell",
  );

  EBook book3 = EBook(
    "E02",
    "Dune",
    6.49,
    5.2,
    "Frank Herbert",
  );

  cart.addItem(book1);
  cart.addItem(book2);
  cart.addItem(book3);

  List<MediaItem> selectedItems = cart.filterByMaxPrice(10.0);

  print("Selected items:");

  for (int i = 0; i < selectedItems.length; i++) {
    print(selectedItems[i].title);
  }

  print("");

  cart.printReceipt();
}