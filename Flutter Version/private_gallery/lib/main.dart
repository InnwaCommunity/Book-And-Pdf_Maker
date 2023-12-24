
import 'package:flutter/material.dart';
import 'package:private_gallery/config/init.dart';
import 'package:private_gallery/config/routes.dart';


final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: 'Main Navigator');
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Private Gallery',
      navigatorKey: navigatorKey,
      onGenerateRoute: Routes.routeGenerator,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
