// lib/screens.dart
import 'package:flutter/material.dart';
import 'data.dart';

/// ==========================================================
/// SIMPLE CART (NO PACKAGES) — Persists quantities across tabs
/// Improved: typed line-items + stable ordering + global cart UI
/// ==========================================================

@immutable
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String section; // Popular / Mains / Drinks

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.section,
  });
}

@immutable
class CartLine {
  final MenuItem item;
  final int qty;
  const CartLine({required this.item, required this.qty});

  double get lineTotal => item.price * qty;
}

class CartModel extends ChangeNotifier {
  final Map<String, int> _qtyById = <String, int>{};
  final Map<String, MenuItem> _itemById = <String, MenuItem>{};
  final List<String> _order = <String>[]; // stable ordering by first add

  bool get isEmpty => _qtyById.isEmpty;
  bool get isNotEmpty => _qtyById.isNotEmpty;

  int get totalItems => _qtyById.values.fold<int>(0, (a, b) => a + b);

  double get totalPrice {
    double total = 0;
    _qtyById.forEach((id, qty) {
      final item = _itemById[id];
      if (item != null && qty > 0) total += item.price * qty;
    });
    return total;
  }

  int quantityOf(String itemId) => _qtyById[itemId] ?? 0;

  /// Stable, typed lines for UI
  List<CartLine> get lines {
    final result = <CartLine>[];
    for (final id in _order) {
      final item = _itemById[id];
      final qty = _qtyById[id] ?? 0;
      if (item != null && qty > 0) {
        result.add(CartLine(item: item, qty: qty));
      }
    }
    return result;
  }

  void add(MenuItem item) {
    _itemById[item.id] = item;
    if (!_order.contains(item.id)) _order.add(item.id);
    _qtyById[item.id] = (_qtyById[item.id] ?? 0) + 1;
    notifyListeners();
  }

  void remove(MenuItem item) {
    final current = _qtyById[item.id] ?? 0;
    if (current <= 1) {
      _removeInternal(item.id);
    } else {
      _qtyById[item.id] = current - 1;
    }
    notifyListeners();
  }

  void setQuantity(MenuItem item, int qty) {
    if (qty <= 0) {
      _removeInternal(item.id);
    } else {
      _itemById[item.id] = item;
      if (!_order.contains(item.id)) _order.add(item.id);
      _qtyById[item.id] = qty;
    }
    notifyListeners();
  }

  void removeAll(MenuItem item) {
    _removeInternal(item.id);
    notifyListeners();
  }

  void clear() {
    _qtyById.clear();
    _itemById.clear();
    _order.clear();
    notifyListeners();
  }

  void _removeInternal(String id) {
    _qtyById.remove(id);
    _itemById.remove(id);
    _order.remove(id);
  }
}

class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child})
    : super(notifier: cart);

  static CartModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(
      scope != null,
      'CartScope not found. Make sure MainScaffold wraps your app.',
    );
    return scope!.notifier!;
  }
}

/// ==========================================================
/// Typed models
/// ==========================================================

@immutable
class Restaurant {
  final String id;
  final String name;
  final String tags;
  final String image;
  final double rating;
  final String time;
  final String delivery;

  const Restaurant({
    required this.id,
    required this.name,
    required this.tags,
    required this.image,
    required this.rating,
    required this.time,
    required this.delivery,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map, int fallbackIndex) {
    String s(dynamic v, String d) => (v == null) ? d : v.toString();
    double d(dynamic v, double def) {
      if (v == null) return def;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? def;
    }

    return Restaurant(
      id: s(map['id'], 'r_$fallbackIndex'),
      name: s(map['name'], 'Restaurant'),
      tags: s(map['tags'], 'Food'),
      image: s(map['image'], kFallbackImage),
      rating: d(map['rating'], 4.5),
      time: s(map['time'], '20-30 min'),
      delivery: s(map['delivery'], 'Free'),
    );
  }
}

@immutable
class OrderSummary {
  final String restaurant;
  final String date;
  final String status;
  final String itemsText;
  final String total;

  const OrderSummary({
    required this.restaurant,
    required this.date,
    required this.status,
    required this.itemsText,
    required this.total,
  });

  int get itemsCount => itemsText.isEmpty ? 0 : itemsText.split(',').length;

  factory OrderSummary.fromMap(Map<String, dynamic> map) {
    String s(dynamic v, String d) => (v == null) ? d : v.toString();
    return OrderSummary(
      restaurant: s(map['restaurant'], 'Restaurant'),
      date: s(map['date'], ''),
      status: s(map['status'], 'Delivered'),
      itemsText: s(map['items'], ''),
      total: s(map['total'], '\$0.00'),
    );
  }
}

/// ==========================================================
/// ROOT: MAIN SCAFFOLD (BOTTOM NAV)
/// ==========================================================

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = const [
    DiscoveryScreen(),
    OrderHistoryScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

/// ==========================================================
/// Shared Cart Bottom Sheet (usable from any screen)
/// ==========================================================

Future<void> showCartBottomSheet(BuildContext context) async {
  final cart = CartScope.of(context);

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      final bottomPad = MediaQuery.of(ctx).viewInsets.bottom;

      return SafeArea(
        child: AnimatedBuilder(
          animation: cart,
          builder: (context, _) {
            final lines = cart.lines;

            return Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    "Cart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${cart.totalItems} items • ${_money(cart.totalPrice)}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),

                  if (lines.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: lines.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final line = lines[index];
                          return _CartLineTile(
                            line: line,
                            onMinus: () => cart.remove(line.item),
                            onPlus: () => cart.add(line.item),
                            onRemoveAll: () => cart.removeAll(line.item),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: cart.totalItems == 0
                          ? null
                          : () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Checkout flow coming soon"),
                                ),
                              );
                            },
                      child: const Text("Proceed to Checkout"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: cart.totalItems == 0
                        ? null
                        : () {
                            cart.clear();
                            Navigator.pop(ctx);
                          },
                    child: const Text("Clear cart"),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

class _CartAppBarAction extends StatelessWidget {
  const _CartAppBarAction();

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final count = cart.totalItems;
        return IconButton(
          tooltip: "Cart",
          onPressed: () => showCartBottomSheet(context),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_basket_outlined),
              if (count > 0)
                Positioned(right: -6, top: -6, child: _Badge(count: count)),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.primary;
    final fg = Theme.of(context).colorScheme.onPrimary;

    final text = count > 99 ? "99+" : "$count";
    return Semantics(
      label: "Cart items: $text",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// ==========================================================
/// FLOW 1: DISCOVERY (HOME)
/// ==========================================================

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  int _bannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivering to",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _showLocationSheet(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Phnom Penh",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ),
          ],
        ),
        actions: [
          const _CartAppBarAction(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications coming soon")),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Safe async pattern in case user navigates away quickly
          await Future<void>.delayed(const Duration(milliseconds: 700));
          if (!mounted) return;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1) Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(
                  elevation: const WidgetStatePropertyAll(0.5),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
                  hintText: "Find food, drinks, groceries...",
                  leading: const Icon(Icons.search, color: Colors.grey),
                  onTap: () => _openSearch(context),
                ),
              ),
            ),

            // 2) Promotional Banners + indicator
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 170,
                    child: PageView.builder(
                      controller: _bannerController,
                      itemCount: promoBanners.length,
                      onPageChanged: (i) => setState(() => _bannerIndex = i),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _NetworkImage(
                              url: promoBanners[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DotsIndicator(
                    count: promoBanners.length,
                    index: _bannerIndex,
                    activeColor: cs.primary,
                    inactiveColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ),

            // 3) Service Categories (Grid)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cat = categories[index];
                  final String name = (cat['name'] ?? 'Category').toString();
                  final int code = (cat['icon'] is int)
                      ? cat['icon'] as int
                      : Icons.category.codePoint;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("$name selected")));
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            IconData(code, fontFamily: 'MaterialIcons'),
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }, childCount: categories.length),
              ),
            ),

            // 4) Flash Sales (Horizontal)
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: "Flash Sales",
                actionLabel: "See all",
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Flash Sales list coming soon"),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final r = Restaurant.fromMap(restaurants[index], index);
                    return SizedBox(
                      width: 150,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openRestaurant(context, r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 110,
                                      width: 150,
                                      child: _NetworkImage(
                                        url: r.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          "50% OFF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                r.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _money(2.99 + (index % 6)),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 5) Popular Restaurants (Title)
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: "Popular Restaurants",
                actionLabel: "Filter",
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Filters coming soon")),
                  );
                },
              ),
            ),

            // 6) Restaurant List (Vertical)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final r = Restaurant.fromMap(restaurants[index], index);
                return _RestaurantCard(
                  restaurant: r,
                  onTap: () => _openRestaurant(context, r),
                );
              }, childCount: restaurants.length),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  void _openRestaurant(BuildContext context, Restaurant r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r)),
    );
  }

  void _openSearch(BuildContext context) {
    showSearch(context: context, delegate: _SimpleSearchDelegate());
  }

  void _showLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose delivery location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text("Phnom Penh"),
                  subtitle: const Text("Default location"),
                  onTap: () => Navigator.pop(ctx),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add_location_alt_outlined),
                  title: const Text("Add new address"),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const _RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: r.id,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 185,
                  width: double.infinity,
                  child: _NetworkImage(url: r.image, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              r.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.tags,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("•", style: TextStyle(color: Colors.grey)),
                      ),
                      Icon(
                        Icons.delivery_dining_outlined,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.delivery,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==========================================================
/// FLOW 2: RESTAURANT DETAIL (Sticky Tabbar + Real Cart Sheet)
/// ==========================================================

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late final List<MenuItem> _items;

  @override
  void initState() {
    super.initState();
    // Demo menu items (replace with API/data.dart later).
    _items = List<MenuItem>.generate(18, (i) {
      final section = (i < 6)
          ? "Popular"
          : (i < 12)
          ? "Mains"
          : "Drinks";
      return MenuItem(
        id: "item_${widget.restaurant.id}_$i",
        name: "$section Item ${i + 1}",
        description: "Delicious $section option made fresh, served fast.",
        price: (section == "Drinks") ? 2.50 + (i % 3) : 4.50 + (i % 4),
        imageUrl: menuItemImages[i % menuItemImages.length],
        section: section,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final cart = CartScope.of(context);

    final popular = _items.where((e) => e.section == "Popular").toList();
    final mains = _items.where((e) => e.section == "Mains").toList();
    final drinks = _items.where((e) => e.section == "Drinks").toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 240.0,
                pinned: true,
                title: innerBoxIsScrolled ? Text(r.name) : null,
                leading: _CircleIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                actions: [
                  // cart in restaurant too (consistent)
                  IconButton(
                    tooltip: "Cart",
                    onPressed: () => showCartBottomSheet(context),
                    icon: const Icon(Icons.shopping_basket_outlined),
                  ),
                  _CircleIconButton(
                    icon: Icons.share,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Share coming soon")),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: r.id,
                        child: _NetworkImage(url: r.image, fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                              Colors.black.withOpacity(0.65),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 18,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.tags,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: "Popular"),
                      Tab(text: "Mains"),
                      Tab(text: "Drinks"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _MenuList(items: popular),
              _MenuList(items: mains),
              _MenuList(items: drinks),
            ],
          ),
        ),

        /// Floating cart summary (auto-updates via CartScope)
        floatingActionButton: AnimatedBuilder(
          animation: cart,
          builder: (context, _) {
            if (cart.totalItems == 0) return const SizedBox.shrink();
            return FloatingActionButton.extended(
              onPressed: () => showCartBottomSheet(context),
              elevation: 4,
              icon: const Icon(Icons.shopping_basket_outlined),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: Row(
                children: [
                  Text(
                    "${cart.totalItems} Items",
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _money(cart.totalPrice),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  final CartLine line;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemoveAll;

  const _CartLineTile({
    required this.line,
    required this.onMinus,
    required this.onPlus,
    required this.onRemoveAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 54,
              height: 54,
              child: _NetworkImage(url: line.item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "${_money(line.item.price)} • ${_money(line.lineTotal)}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: onMinus,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  "${line.qty}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: onPlus,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'remove') onRemoveAll();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'remove', child: Text("Remove")),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  final List<MenuItem> items;
  const _MenuList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 120),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: Colors.black12,
      ),
      itemBuilder: (context, index) => _MenuItemTile(item: items[index]),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItem item;
  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final qty = cart.quantityOf(item.id);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 92,
              height: 92,
              child: _NetworkImage(url: item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _money(item.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // Quantity selector
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: qty == 0
                          ? InkWell(
                              key: const ValueKey("add"),
                              onTap: () => cart.add(item),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              key: const ValueKey("stepper"),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => cart.remove(item),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$qty",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => cart.add(item),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Delegate helper for Sticky Header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

/// ==========================================================
/// FLOW 3: ORDERS
/// ==========================================================

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasOrders = orderHistory.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        actions: const [_CartAppBarAction()],
      ),
      body: hasOrders
          ? ListView.builder(
              itemCount: orderHistory.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = OrderSummary.fromMap(orderHistory[index]);

                return Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderReceiptScreen(order: order),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.store,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.restaurant,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      order.date,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${order.itemsCount} Items",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                order.total,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : _EmptyState(
              icon: Icons.receipt_long_outlined,
              title: "No orders yet",
              subtitle: "Your recent orders will show here.",
              actionLabel: "Explore restaurants",
              onAction: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Go to Discovery tab")),
                );
              },
            ),
    );
  }
}

class OrderReceiptScreen extends StatelessWidget {
  final OrderSummary order;
  const OrderReceiptScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        actions: const [_CartAppBarAction()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Order Delivered",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Thank you for ordering!",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  _row("Restaurant", order.restaurant),
                  _row("Date", order.date),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  _row("Total", order.total, isBold: true),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reorder coming soon")),
                  );
                },
                child: const Text("Reorder"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _row(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            val,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================================================
/// FLOW 4: ABOUT
/// ==========================================================

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        actions: const [_CartAppBarAction()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              backgroundColor: primary.withOpacity(0.12),
              child: Icon(Icons.delivery_dining, size: 50, color: primary),
            ),
            const SizedBox(height: 20),
            Text(
              "Food Delivery App",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text("Version 2.2.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text("Development Team"),
              subtitle: const Text("Srun Sochettra, Tep Makara, Som Chanrah, Kong Chanreaksmey"),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Theme"),
              subtitle: const Text("Material 3 • Use your brand color"),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Theme settings coming soon")),
                );
              },
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {},
            ),
            const Divider(height: 1),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Tip: Use the bottom navigation bar for quick access to Home, Orders, and Settings.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// ==========================================================
/// SHARED UI HELPERS
/// ==========================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }
}


class _NetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const _NetworkImage({
    required this.url,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      filterQuality: FilterQuality.low,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              value: progress.expectedTotalBytes == null
                  ? null
                  : progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        );
      },
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  const _DotsIndicator({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 7,
          width: active ? 18 : 7,
          decoration: BoxDecoration(
            color: active ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _SimpleSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "Search restaurants, items...";

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ""),
  );

  @override
  Widget buildResults(BuildContext context) {
    final q = query.toLowerCase().trim();

    // Minimal demo: filter restaurants by name/tags
    final results = restaurants
        .asMap()
        .entries
        .map((e) => Restaurant.fromMap(e.value, e.key))
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.tags.toLowerCase().contains(q),
        )
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text("No results"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final r = results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: _NetworkImage(url: r.image, fit: BoxFit.cover),
            ),
          ),
          title: Text(r.name),
          subtitle: Text(r.tags),
          onTap: () {
            close(context, r.name);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(restaurant: r),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    const suggestions = <String>[
      "Pizza",
      "Burger",
      "Coffee",
      "Sushi",
      "Fried Chicken",
    ];
    final filtered = suggestions
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: filtered
          .map(
            (s) => ListTile(
              leading: const Icon(Icons.search),
              title: Text(s),
              onTap: () => query = s,
            ),
          )
          .toList(),
    );
  }
}

/// Small helpers
String _money(double v) => "\$${v.toStringAsFixed(2)}";
