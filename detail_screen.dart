
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  int quantity = 1;
  String selectedSize = '250g';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE BANNER
                    SizedBox(
                      height: 270,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFEEA4A0),
                            child: const Center(
                              child: Icon(
                                Icons.coffee,
                                size: 130,
                                color: Color(0xFF3C3351),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 15,
                            left: 15,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          Positioned(
                            top: 15,
                            right: 15,
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color(0xFF3C3351),
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Guatemala Antigua',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3C3351),
                                  ),
                                ),
                              ),
                              Text(
                                '\$14.50',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEEA4A0),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFFFC067),
                                size: 20,
                              ),
                              Text('4.8 (120 reviews)'),
                            ],
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'A balanced and bright coffee '
                            'with notes of cocoa, citrus '
                            'and caramel.',
                          ),

                          const SizedBox(height: 20),

                          const Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Chip(label: Text('Origin: Guatemala')),
                              Chip(label: Text('Roast: Medium')),
                              Chip(label: Text('Altitude: 1500m')),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Tasting notes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text('Cocoa')),
                              Chip(label: Text('Citrus')),
                              Chip(label: Text('Caramel')),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Size',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 10,
                            children: ['250g', '500g', '1kg']
                                .map((size) {
                              return ChoiceChip(
                                label: Text(size),
                                selected: selectedSize == size,
                                selectedColor:
                                    const Color(0xFFFFC067),
                                onSelected: (value) {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),

                              const Spacer(),

                              IconButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                ),
                              ),

                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ADD TO CART BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFC067),
                    foregroundColor:
                        const Color(0xFF3C3351),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          '$quantity x $selectedSize added to cart!',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
