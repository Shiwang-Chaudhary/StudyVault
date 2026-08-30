import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';

final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(userProfileProvider).requireValue.id;
});
