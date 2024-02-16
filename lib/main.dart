import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewModels/home_view_model.dart';
import 'views/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Coding Assignment Pidilite Ventures',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        builder: (context, _) => const HomeScreen(),
      ),
    );
  }
}
