import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DatabaseHelper.dart';
import 'IncidentRepository.dart';
import 'ParkingRepository.dart';
import 'package:proyecto_final/pages/main_page.dart';

// Use provider - flutter
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),
        Provider<IncidentRepository>(create: (context) => IncidentRepository(context.read<DatabaseHelper>())),
        Provider<ParkingRepository>(create: (_) => ParkingRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: Colors.greenAccent);
    return MaterialApp(
      title: "parking",
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: ThemeData.from(colorScheme: colorScheme).appBarTheme.copyWith(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.background,
        ),
      ),
      home: MainPage(),
    );
  }
}
