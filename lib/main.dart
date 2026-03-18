import 'package:flutter/material.dart';
import 'package:brownyplus/feature/authentication/view/loading_screen.dart';
import 'package:brownyplus/core/res/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrownyPlus',
      theme: AppTheme.light,
      home: const LoadingScreen(),
    );
  }
}
