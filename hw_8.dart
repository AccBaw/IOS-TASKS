
import 'package:flutter/material.dart';

void main() => runApp(const CoffeeApp());

class Coffee {
  final int id;
  final String name;
  final String type;
  final int price;
  final double rating;
  final IconData icon;

  const Coffee({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
    required this.icon,
  });
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Beans',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF795548),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      ),
      home: const CoffeeCatalog(),
    );
  }
}

class CoffeeCatalog extends StatefulWidget {
  const CoffeeCatalog({super.key});

  @override
  State<CoffeeCatalog> createState() => _CoffeeCatalogState();
}

class _CoffeeCatalogState extends State<CoffeeCatalog> {
  bool gridMode = true;
  int newId = 50;

  List<Coffee> coffees = [];

  List<Coffee> initialCoffee() => [
        const Coffee(
          id: 1,
          name: 'Colombian Arabica',
          type: 'Medium Roast',
          price: 4500,
          rating: 4.8,
          icon: Icons.coffee,
        ),
        const Coffee(
          id: 2,
          name: 'Ethiopian Sidamo',
          type: 'Light Roast',
          price: 5200,
          rating: 4.9,
          icon: Icons.local_cafe,
        ),
        const Coffee(
          id: 3,
          name: 'Brazil Santos',
          type: 'Dark Roast',
          price: 3900,
          rating: 4.6,
          icon: Icons.coffee_maker,
        ),
        const Coffee(
          id: 4,
          name: 'Kenya AA',
          type: 'Medium Roast',
          price: 5600,
          rating: 4.9,
          icon: Icons.coffee,
        ),
        const Coffee(
          id: 5,
          name: 'Guatemala Antigua',
          type: 'Medium Roast',
          price: 4800,
          rating: 4.7,
          icon: Icons.local_cafe,
        ),
        const Coffee(
          id: 6,
          name: 'Italian Espresso',
          type: 'Dark Roast',
          price: 4200,
          rating: 4.8,
          icon: Icons.coffee_maker,
        ),
      ];

  @override
  void initState() {
    super.initState();
    coffees = initialCoffee();
  }

  Future<void> reloadCoffee() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    if (!mounted) return;

    setState(() {
      coffees.insert(
        0,
        Coffee(
          id: newId++,
          name: 'Fresh Coffee Blend',
          type: 'Special Edition',
          price: 4900,
          rating: 5.0,
          icon: Icons.coffee,
        ),
      );
    });
  }

  void removeCoffee(Coffee coffee) {
    final oldIndex = coffees.indexWhere(
      (item) => item.id == coffee.id,
    );

    if (oldIndex == -1) return;

    setState(() {
      coffees.removeAt(oldIndex);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF4E342E),
        content: Text('${coffee.name} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              coffees.insert(
                oldIndex.clamp(0, coffees.length),
                coffee,
              );
            });
          },
        ),
      ),
    );
  }

  Widget coffeeList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: coffees.length,
      separatorBuilder: (_, __) => const Divider(
        thickness: 0.5,
        color: Color(0xFFD7CCC8),
      ),
      itemBuilder: (context, index) {
        final coffee = coffees[index];

        return Dismissible(
          key: ValueKey(coffee.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          onDismissed: (_) => removeCoffee(coffee),
          child: ListTile(
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: const Color(0xFFD7CCC8),
              child: Icon(
                coffee.icon,
                color: const Color(0xFF5D4037),
                size: 28,
              ),
            ),
            title: Text(
              coffee.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coffee.type),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Text(' ${coffee.rating}'),
                  ],
                ),
              ],
            ),
            trailing: Text(
              '${coffee.price} ₸',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget coffeeGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: coffees.length,
      itemBuilder: (context, index) {
        final coffee = coffees[index];

        return Card(
          key: ValueKey(coffee.id),
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEBE9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      coffee.icon,
                      size: 60,
                      color: const Color(0xFF795548),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  coffee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coffee.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.brown,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Text(' ${coffee.rating}'),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${coffee.price} ₸',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget noCoffee() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.coffee_outlined,
            size: 85,
            color: Colors.brown,
          ),
          const SizedBox(height: 16),
          const Text(
            'Catalog is Empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('No coffee beans available'),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                coffees = initialCoffee();
              });
            },
            icon: const Icon(Icons.refresh),
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
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text('Coffee Beans'),
        actions: [
          IconButton(
            tooltip: 'Change catalog view',
            icon: Icon(
              gridMode ? Icons.view_list : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                gridMode = !gridMode;
              });
            },
          ),
        ],
      ),
      body: coffees.isEmpty
          ? noCoffee()
          : RefreshIndicator(
              color: Colors.brown,
              onRefresh: reloadCoffee,
              child: gridMode ? coffeeGrid() : coffeeList(),
            ),
    );
  }
}
