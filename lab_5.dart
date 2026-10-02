import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Comics'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [

                Image.network(
                  'https://imagecomics.com/files/releases/0623IM805-hires.jpg',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),

                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.bookmark_border,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transformers #1',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Skybound Entertainment',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),

                      const SizedBox(width: 5),
                      const Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        '\$4.99',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [

                      Chip(
                        label: Text('Sci-Fi'),
                      ),

                      Chip(
                        label: Text('Action'),
                      ),

                      Chip(
                        label: Text('Robots'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'THE ALL NEW TRANSFORMERS ERA STARTS HERE! Optimus Prime was supposed to have led the Autobots to victory. Instead, the fate of Cybertron is unknown, and his allies have crash-landed far from home, alongside their enemies—the Decepticons. As these titanic forces renew their war on Earth, one thing is immediately clear: the planet will never be the same. New alliances are struck. Battle lines are redrawn. And humanity’s only hope of survival is Optimus Prime.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),


          child: Row(
            children: [

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                      ),
                    );
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
