import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddressNotifier extends StateNotifier<String?> {
  AddressNotifier() : super(null);

  final _supabase = Supabase.instance.client;

  /// LOAD ADDRESS
  Future<void> loadAddress() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('user_addresses')
        .select('address')
        .eq('user_id', user.id)
        .maybeSingle();

    if (response != null) {
      state = response['address'];
    }
  }

  /// SAVE OR UPDATE ADDRESS
  Future<void> saveAddress(String address) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final existing = await _supabase
        .from('user_addresses')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (existing == null) {
      await _supabase.from('user_addresses').insert({
        'user_id': user.id,
        'address': address,
      });
    } else {
      await _supabase
          .from('user_addresses')
          .update({'address': address}).eq('user_id', user.id);
    }

    state = address;
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, String?>((ref) {
  return AddressNotifier();
});
