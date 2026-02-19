import 'dart:ui';

class Product {
  Product({
    required this.description,
    required this.reviews,
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    this.tags = const [],
  });

  final String id;
  final String title;
  final int price;
  final String image;
  final Category category;
  final String description;
  final int reviews;
  final List<ProductTag> tags;
}

enum Category {
  starbucks,
  nescafe,
  folgers,
  lavazza,
  jacobs,
  timhortons,
}

extension CategoryExtension on Category {
  /// Primary background color for the category
  Color get color {
    switch (this) {
      case Category.starbucks:
        return const Color(0xFFC9873A);
      case Category.nescafe:
        return const Color(0xFF7A3A22);
      case Category.folgers:
        return const Color(0xFFB53A2D);
      case Category.lavazza:
        return const Color(0xFF1F3A5F);
      case Category.jacobs:
        return const Color(0xFF2E5E4E);
      case Category.timhortons:
        return const Color(0xFF8B1E1E);
    }
  }

  /// Human-readable name for UI
  String toName() {
    switch (this) {
      case Category.starbucks:
        return 'Starbucks';
      case Category.nescafe:
        return 'Nescafe';
      case Category.folgers:
        return 'Folgers';
      case Category.lavazza:
        return 'Lavazza';
      case Category.jacobs:
        return 'Jacobs';
      case Category.timhortons:
        return 'Tim Hortons';
    }
  }
}

enum ProductTag {
  bestSelling,
  newArrival,
  onSale,
}

extension ProductTagExtension on ProductTag {
  /// Returns a human-friendly display string for the tag.
  ///
  /// Examples:
  /// - `ProductTag.bestSelling.toName()` -> 'Best Selling'
  /// - `ProductTag.newArrival.toName()` -> 'New Arrival'
  String toName() {
    switch (this) {
      case ProductTag.bestSelling:
        return 'Best Selling';
      case ProductTag.newArrival:
        return 'New Arrival';
      case ProductTag.onSale:
        return 'On Sale';
    }
  }
}
