import 'package:flutter/material.dart';

import 'features/lots/presentation/providers/lot_provider.dart';
import 'features/lots/presentation/screens/create_lot_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LotProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: const Color(0xFFB86A1B),
        ),
        home: const LotsPage(),
      ),
    );
  }
}