
import 'package:flutter/material.dart';

void main() => runApp(const SmartCatalogApp());

class Product {
  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final IconData icon;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
  });
}

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tech Catalog',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool isGrid = false;
  int nextId = 100;

  List<Product> products = [];

  List<Product> seedProducts() => [
        const Product(
          id: 1,
          title: 'Wireless Headphones',
          category: 'Audio',
          price: 89.99,
          rating: 4.8,
          icon: Icons.headphones,
        ),
        const Product(
          id: 2,
          title: 'Smart Watch',
          category: 'Wearables',
          price: 149.99,
          rating: 4.7,
          icon: Icons.watch,
        ),
        const Product(
          id: 3,
          title: 'Bluetooth Speaker',
          category: 'Audio',
          price: 59.99,
          rating: 4.5,
          icon: Icons.speaker,
        ),
        const Product(
          id: 4,
          title: 'Gaming Mouse',
          category: 'Accessories',
          price: 39.99,
          rating: 4.6,
          icon: Icons.mouse,
        ),
        const Product(
          id: 5,
          title: 'Laptop',
          category: 'Computers',
          price: 999.99,
          rating: 4.9,
          icon: Icons.laptop,
        ),
        const Product(
          id: 6,
          title: 'Smartphone',
          category: 'Phones',
          price: 699.99,
          rating: 4.8,
          icon: Icons.smartphone,
        ),
      ];

  @override
  void initState() {
    super.initState();
    products = seedProducts();
  }

  Future<void> refreshCatalog() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    if (!mounted) return;

    setState(() {
      products.insert(
        0,
        Product(
          id: nextId++,
          title: 'New Tech Product',
          category: 'New Arrival',
          price: 79.99,
          rating: 4.9,
          icon: Icons.devices,
        ),
      );
    });
  }

  void deleteProduct(Product product) {
    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) return;

    setState(() {
      products.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('${product.title} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              products.insert(
                index.clamp(0, products.length),
                product,
              );
            });
          },
        ),
      ),
    );
  }

  Widget productList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 0.5,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) => deleteProduct(product),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.indigo.shade100,
              child: Icon(
                product.icon,
                color: Colors.indigo,
              ),
            ),
            title: Text(
              product.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.category),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    Text(' ${product.rating}'),
                  ],
                ),
              ],
            ),
            trailing: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget productGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          key: ValueKey(product.id),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      product.icon,
                      size: 65,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    Text(' ${product.rating}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 90,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Catalog is Empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                products = seedProducts();
              });
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset Catalog'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Tech Catalog'),
        actions: [
          IconButton(
            tooltip: 'Toggle view',
            icon: Icon(
              isGrid ? Icons.view_list : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? emptyState()
          : RefreshIndicator(
              onRefresh: refreshCatalog,
              child: isGrid ? productGrid() : productList(),
            ),
    );
  }
}
