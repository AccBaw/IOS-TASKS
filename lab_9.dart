
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

// PRODUCT MODEL
class Product {
  final String name;
  final double price;
  final IconData icon;

  const Product(this.name, this.price, this.icon);
}

// GLOBAL CART PROVIDER
class CartProvider extends ChangeNotifier {
  final List<Product> products = const [
    Product('Espresso', 900, Icons.coffee),
    Product('Latte', 1400, Icons.local_cafe),
    Product('Cappuccino', 1300, Icons.coffee_maker),
    Product('Americano', 1000, Icons.local_drink),
    Product('Mocha', 1600, Icons.emoji_food_beverage),
    Product('Flat White', 1500, Icons.free_breakfast),
  ];

  final List<Product> _cart = [];

  List<Product> get cart => List.unmodifiable(_cart);

  int get itemCount => _cart.length;

  double get totalPrice =>
      _cart.fold(0, (sum, product) => sum + product.price);

  bool isInCart(Product product) {
    return _cart.contains(product);
  }

  void toggleCart(Product product) {
    if (_cart.contains(product)) {
      _cart.remove(product);
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

// MAIN APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Cart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

// SCREEN 1: CATALOG
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Catalog'),
        backgroundColor: Colors.brown.shade200,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 3,
                  top: 3,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cart.products.length,
        itemBuilder: (context, index) {
          final product = cart.products[index];
          final selected = cart.isInCart(product);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade100,
                child: Icon(
                  product.icon,
                  color: Colors.brown,
                ),
              ),
              title: Text(product.name),
              subtitle: Text('${product.price.toInt()} KZT'),
              trailing: ElevatedButton(
                onPressed: () {
                  cart.toggleCart(product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected
                      ? Colors.brown.shade100
                      : Colors.brown,
                  foregroundColor: selected
                      ? Colors.brown
                      : Colors.white,
                ),
                child: Text(
                  selected ? 'Remove' : 'Add to Cart',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// SCREEN 2: CART
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart (${cart.itemCount})'),
        backgroundColor: Colors.brown.shade200,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.cart.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.cart.length,
                    itemBuilder: (context, index) {
                      final product = cart.cart[index];

                      return Card(
                        child: ListTile(
                          leading: Icon(
                            product.icon,
                            color: Colors.brown,
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                            '${product.price.toInt()} KZT',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              cart.removeItem(product);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Total: ${cart.totalPrice.toInt()} KZT',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: cart.cart.isEmpty
                        ? null
                        : () => cart.clearCart(),
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear All'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
