class ProductReview {
  final String id;
  final String productId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  /// Convert Supabase JSON → Review
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      productId: json['product_id'],
      userName: json['user_name'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
