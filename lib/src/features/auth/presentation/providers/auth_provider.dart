import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authStateProvider = StateProvider<bool>((ref) => false);

final authLoadingProvider = StateProvider<bool>((ref) => false);

final userProvider = StateProvider<Map<String, dynamic>?>((ref) => null);