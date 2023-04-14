import 'package:flutter/material.dart';
import 'package:flutter_music_app/representation/screens/music_player_screen.dart';
import 'package:get/get.dart';

import 'representation/screens/home_page_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePageScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomePageScreen()),
        GetPage(name: '/player', page: () => const MusicPlayerScreen()),
      ],
    );
  }
}
