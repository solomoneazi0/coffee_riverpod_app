import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

/// 🔹 Fetch reviews for a specific product
final reviewsByProductProvider =
    FutureProvider.family<List<ProductReview>, String>((ref, productId) async {
  final response = await _supabase
      .from('product_reviews')
      .select()
      .eq('product_id', productId)
      .order('created_at', ascending: false);

  return response
      .map<ProductReview>((json) => ProductReview.fromJson(json))
      .toList();
});
