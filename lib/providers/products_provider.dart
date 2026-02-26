import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';

List<Product> allProducts() {
  return [
    Product(
      id: '1',
      title: 'House Blend',
      price: 999,
      image: 'assets/images/espressotoast.png',
      category: Category.starbucks,
      description: '',
      reviews: 3,
      tags: [
        ProductTag.bestSelling,
        ProductTag.onSale,
        ProductTag.newArrival,
        ProductTag.all
      ],
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '2',
      title: 'Nescafé Decaf',
      price: 699,
      image: 'assets/images/espressotoast.png',
      category: Category.nescafe,
      description: '',
      reviews: 5,
      tags: [ProductTag.bestSelling, ProductTag.onSale, ProductTag.all],
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '3',
      title: 'Brio Italian',
      price: 199,
      image: 'assets/images/Brio.png',
      category: Category.folgers,
      description: '',
      reviews: 2,
      tags: [
        ProductTag.newArrival,
        ProductTag.onSale,
        ProductTag.bestSelling,
        ProductTag.all
      ],
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '4',
      title: 'Espresso Italiano',
      price: 299,
      image: 'assets/images/Brio.png',
      category: Category.lavazza,
      description: '',
      reviews: 4,
      tags: [
        ProductTag.newArrival,
        ProductTag.onSale,
        ProductTag.bestSelling,
        ProductTag.all
      ],
      rating: const StarRating(value: 3),
    ),
    Product(
      id: '5',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.jacobs,
      description: '',
      reviews: 3,
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '6',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 4,
      tags: [
        ProductTag.newArrival,
        ProductTag.onSale,
        ProductTag.bestSelling,
        ProductTag.all
      ],
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '7',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 2,
      rating: const StarRating(value: 4),
    ),
    Product(
      id: '8',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 4,
      tags: [
        ProductTag.newArrival,
        ProductTag.onSale,
        ProductTag.bestSelling,
        ProductTag.all
      ],
      rating: const StarRating(value: 4),
    ),
  ];
}

final productProvider = Provider((ref) {
  return allProducts();
});

final featuredProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.tags.contains(ProductTag.bestSelling))
      .toList();
});

final newArrivalProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.tags.contains(ProductTag.newArrival))
      .toList();
});

final onSaleProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.tags.contains(ProductTag.onSale))
      .toList();
});

final starbucksProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.starbucks)
      .toList();
});

final nescafeProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.nescafe)
      .toList();
});

final folgersProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.folgers)
      .toList();
});

final lavazzaProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.lavazza)
      .toList();
});

final jacobsProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.jacobs)
      .toList();
});

final timhortonsProductsProvider = Provider((ref) {
  final products = ref.watch(productProvider);
  return products
      .where((product) => product.category == Category.timhortons)
      .toList();
});

final categoryCountProvider = Provider.family<int, Category>((ref, category) {
  final products = ref.watch(productProvider);

  return products.where((p) => p.category == category).length;
});

// Dynamic provider to get products by category (used in ProductScreen for dynamic listing)
final productsByCategoryProvider =
    Provider.family<List<Product>, Category>((ref, category) {
  final products = ref.watch(productProvider);
  return products.where((p) => p.category == category).toList();
});

// For dynamic product listing based on selected tab (e.g., new arrivals, best selling)

final productTabProvider = StateProvider<ProductTag>((ref) => ProductTag.all);

// This provider gives us the filtered products based on the selected tab and category
final filteredProductsProvider =
    Provider.family<List<Product>, Category>((ref, category) {
  final selectedTag = ref.watch(productTabProvider);
  final products = ref.watch(productsByCategoryProvider(category));

  // 👇 If ALL is selected, return everything
  if (selectedTag == ProductTag.all) {
    return products;
  }

  // 👇 Otherwise, filter by tag
  return products
      .where((product) => product.tags.contains(selectedTag))
      .toList();
});
