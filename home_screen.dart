
import 'package:flutter/material.dart';
import '../widgets/coffee_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Dark',
    'Medium',
    'Light',
  ];

  void openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Row(
                children: [
                  Text(
                    'GOOD MORNING',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.wb_sunny_outlined,
                    color: Color(0xFFFFC067),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const Text(
                'Find your perfect\nbeans',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C3351),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search coffee beans...',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    bool selected =
                        selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        selectedColor:
                            const Color(0xFFFFC067),
                        backgroundColor:
                            const Color(0xFFF7E7CE),
                        onSelected: (value) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.72,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    CoffeeCard(
                      name: 'Guatemala Antigua',
                      price: '\$14.50',
                      color: const Color(0xFFEEA4A0),
                      onTap: openDetails,
                    ),
                    CoffeeCard(
                      name: 'Colombia Supremo',
                      price: '\$15.00',
                      color: const Color(0xFFFFC067),
                      onTap: openDetails,
                    ),
                    CoffeeCard(
                      name: 'Ethiopia Yirgacheffe',
                      price: '\$16.00',
                      color: const Color(0xFFF7E7CE),
                      onTap: openDetails,
                    ),
                    CoffeeCard(
                      name: 'Ethiopia Sidamo',
                      price: '\$13.50',
                      color: const Color(0xFF917FC1),
                      onTap: openDetails,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3C3351),
        unselectedItemColor: const Color(0xFF917FC1),
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coming soon!'),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
