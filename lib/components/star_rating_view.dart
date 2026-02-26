// lib/widgets/star_rating_view.dart
import 'package:flutter/material.dart';
import 'package:riverpod_files/models/product.dart';

class StarRatingView extends StatelessWidget {
  final StarRating rating;

  const StarRatingView({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(rating.maxStars, (index) {
        final starIndex = index + 1;

        return Icon(
          starIndex <= rating.value
              ? Icons.star
              : starIndex - rating.value <= 0.5
                  ? Icons.star_half
                  : Icons.star_border,
          size: 18,
          color: Colors.amber,
        );
      }),
    );
  }
}
