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
      reviews: 0,
      tags: [ProductTag.bestSelling, ProductTag.onSale],
    ),
    Product(
      id: '2',
      title: 'Nescafé Decaf',
      price: 699,
      image: 'assets/images/espressotoast.png',
      category: Category.nescafe,
      description: '',
      reviews: 0,
      tags: [ProductTag.bestSelling, ProductTag.onSale],
    ),
    Product(
      id: '3',
      title: 'Brio Italian',
      price: 199,
      image: 'assets/images/Brio.png',
      category: Category.folgers,
      description: '',
      reviews: 0,
      tags: [ProductTag.newArrival, ProductTag.onSale, ProductTag.bestSelling],
    ),
    Product(
      id: '4',
      title: 'Espresso Italiano',
      price: 299,
      image: 'assets/images/Brio.png',
      category: Category.lavazza,
      description: '',
      reviews: 0,
      tags: [ProductTag.newArrival, ProductTag.onSale, ProductTag.bestSelling],
    ),
    Product(
      id: '5',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.jacobs,
      description: '',
      reviews: 0,
    ),
    Product(
      id: '6',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 0,
      tags: [ProductTag.newArrival, ProductTag.onSale, ProductTag.bestSelling],
    ),
    Product(
      id: '7',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 0,
    ),
    Product(
      id: '8',
      title: 'Jacobs Barista Crema',
      price: 499,
      image: 'assets/images/Brio.png',
      category: Category.starbucks,
      description: '',
      reviews: 0,
      tags: [ProductTag.newArrival, ProductTag.onSale, ProductTag.bestSelling],
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
