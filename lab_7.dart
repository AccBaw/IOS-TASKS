
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Product data
class Product {
  String title;
  String description;
  String image;
  double price;
  String category;

  Product(this.title, this.description, this.image,
      this.price, this.category);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// Main screen with tabs
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  List<Product> products = [
    Product(
      'Espresso',
      'Strong and rich coffee.',
      'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=600',
      1200,
      'Coffee',
    ),
    Product(
      'Cappuccino',
      'Coffee with steamed milk and foam.',
      'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600',
      1500,
      'Coffee',
    ),
    Product(
      'Latte',
      'Smooth coffee with creamy milk.',
      'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600',
      1600,
      'Coffee',
    ),
  ];

  List<Product> favorites = [];

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }

  void openDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          product: product,
          isFavorite: favorites.contains(product),
          onFavorite: () {
            toggleFavorite(product);
          },
        ),
      ),
    );
  }

  Widget buildProductList(List<Product> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No favorite products yet'),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        Product product = items[index];

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              product.image,
              width: 65,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.coffee, size: 40);
              },
            ),
            title: Text(product.title),
            subtitle: Text('${product.price.toInt()} KZT'),
            trailing: IconButton(
              icon: Icon(
                favorites.contains(product)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                toggleFavorite(product);
              },
            ),
            onTap: () {
              openDetails(product);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop'),
        centerTitle: true,
        backgroundColor: Colors.brown.shade200,
      ),

      body: IndexedStack(
        index: selectedTab,
        children: [
          buildProductList(products),
          buildProductList(favorites),
          const ProfileScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        selectedItemColor: Colors.brown,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Product detail screen
class DetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const DetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Colors.brown.shade200,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.coffee, size: 100);
                },
              ),

              const SizedBox(height: 20),

              Text(
                widget.product.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Category: ${widget.product.category}',
              ),

              const SizedBox(height: 10),

              Text(
                '${widget.product.price.toInt()} KZT',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.brown,
                ),
              ),

              const SizedBox(height: 20),

              Text(widget.product.description),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  widget.onFavorite();
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile tab
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
          SizedBox(height: 15),
          Text(
            'Coffee Lover',
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 10),
          Text('coffee@example.com'),
          SizedBox(height: 10),
          Text('Member of Coffee Shop'),
        ],
      ),
    );
  }
}
