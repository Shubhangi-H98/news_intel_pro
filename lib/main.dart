import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_intel_pro/src/features/favorites/auth/presentation/screens/login_screen.dart';
import 'src/features/news/data/models/article_model.dart';
import 'src/features/news/presentation/screens/news_feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ArticleModelAdapter());

  await Hive.openBox<ArticleModel>('favorites');

  // --- NAYA CODE: Auth box kholiye ---
  await Hive.openBox('auth_box');
  // ---------------------------------

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- NAYA CODE: Login state check karein ---
    final authBox = Hive.box('auth_box');
    final bool isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);
    // -----------------------------------------

    return MaterialApp(
      title: 'News Intel Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // isLoggedIn ke basis par screen decide hogi
      home: isLoggedIn ? const NewsFeedScreen() : const LoginScreen(),
    );
  }
}