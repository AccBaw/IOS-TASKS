
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const FashionStoreApp());
}

// =====================================================
// 1. PRODUCT MODEL
// =====================================================

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'];

    final ratingMap = ratingData is Map
        ? Map<String, dynamic>.from(ratingData)
        : <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown Product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description:
          json['description'] as String? ?? 'No description available.',
      category: json['category'] as String? ?? 'Other',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingMap['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }
}

// =====================================================
// 2. API SERVICE
// =====================================================

class ProductService {
  static const String womenUrl =
      "https://fakestoreapi.com/products/category/women's%20clothing";

  static const String jewelryUrl =
      'https://fakestoreapi.com/products/category/jewelery';

  static Future<List<Product>> fetchCategory(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const FormatException('Invalid product data');
      }

      return decoded.map((item) {
        return Product.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    }

    if (response.statusCode == 404) {
      throw Exception('404: Products not found');
    }

    if (response.statusCode >= 500) {
      throw Exception(
        'Server error: ${response.statusCode}',
      );
    }

    throw Exception(
      'HTTP error: ${response.statusCode}',
    );
  }

  // Load both categories at the same time.
  static Future<List<Product>> fetchProducts() async {
    final results = await Future.wait([
      fetchCategory(womenUrl),
      fetchCategory(jewelryUrl),
    ]).timeout(const Duration(seconds: 10));

    return [
      ...results[0],
      ...results[1],
    ];
  }
}

// =====================================================
// 3. MAIN APPLICATION
// =====================================================

class FashionStoreApp extends StatelessWidget {
  const FashionStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion & Jewelry',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8D735B),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFECE5DD),
          centerTitle: true,
        ),
      ),
      home: const ProductFeedScreen(),
    );
  }
}

// =====================================================
// 4. PRODUCT FEED SCREEN
// =====================================================

class ProductFeedScreen extends StatefulWidget {
  const ProductFeedScreen({super.key});

  @override
  State<ProductFeedScreen> createState() =>
      _ProductFeedScreenState();
}

class _ProductFeedScreenState extends State<ProductFeedScreen> {
  List<Product> products = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts({
    bool showLoading = true,
  }) async {
    if (showLoading) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final result = await ProductService.fetchProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;

        errorMessage = e is TimeoutException
            ? 'Connection timed out. Please try again.'
            : 'Could not load products.\n$e';
      });
    }
  }

  Widget productImage(
    String url, {
    double size = 70,
  }) {
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_not_supported_outlined,
        size: size * 0.5,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    // STATE 1: LOADING
    if (isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    // STATE 2: ERROR + RETRY
    else if (errorMessage != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 70,
                color: Color(0xFF8D735B),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connection Problem',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => loadProducts(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      );
    }

    // STATE 3: SUCCESS
    else {
      body = RefreshIndicator(
        onRefresh: () => loadProducts(showLoading: false),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = products[index];

            return Card(
              color: Colors.white,
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),

                // HERO IMAGE
                leading: Hero(
                  tag: 'product_image_${product.id}',
                  child: productImage(product.imageUrl),
                ),

                title: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8D735B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.orange,
                        ),
                        Text(
                          ' ${product.rating.toStringAsFixed(1)} '
                          '(${product.reviewCount})',
                        ),
                      ],
                    ),
                  ],
                ),

                trailing: const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        product: product,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashion & Jewelry'),
      ),
      body: body,
    );
  }
}

// =====================================================
// 5. PRODUCT DETAIL SCREEN
// =====================================================

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  // FakeStoreAPI provides one image per product.
  // Repeated to demonstrate a 3-page carousel.
  List<String> get photos => List.filled(
        3,
        widget.product.imageUrl,
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // ===================================================
  // SHARE DEEP LINK BOTTOM SHEET
  // ===================================================

  void showShareSheet() {
    final link =
        'narxoz://store/product/${widget.product.id}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share Product',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text('Product Deep Link:'),

            const SizedBox(height: 10),

            SelectableText(link),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copy Link'),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: link),
                  );

                  if (!sheetContext.mounted) return;

                  Navigator.pop(sheetContext);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied!'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            tooltip: 'Share product',
            icon: const Icon(Icons.share_outlined),
            onPressed: showShareSheet,
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===================================
                  // HERO + PHOTO CAROUSEL
                  // ===================================

                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: pageController,
                          itemCount: photos.length,
                          onPageChanged: (page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            final image = Image.network(
                              photos[index],
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(
                                Icons.broken_image_outlined,
                                size: 80,
                              ),
                            );

                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: index == 0
                                  ? Hero(
                                      tag:
                                          'product_image_${product.id}',
                                      child: image,
                                    )
                                  : image,
                            );
                          },
                        ),

                        // PAGE COUNTER
                        Positioned(
                          top: 12,
                          right: 16,
                          child: Chip(
                            label: Text(
                              '${currentPage + 1} / ${photos.length}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===================================
                  // ANIMATED DOT INDICATORS
                  // ===================================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      photos.length,
                      (index) => AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        width: currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? const Color(0xFF8D735B)
                              : Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // ===================================
                  // PRODUCT INFORMATION
                  // ===================================

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text(
                            product.category.toUpperCase(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(
                              ' ${product.rating.toStringAsFixed(1)} '
                              '(${product.reviewCount} reviews)',
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8D735B),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===========================================
          // STICKY ADD TO CART BUTTON
          // ===========================================

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D735B),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.title} added to cart!',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
