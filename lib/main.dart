import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/ProductModel.dart';

import 'package:shopapp/providers/repo.dart';
import 'package:shopapp/providers/themeprovider.dart';
import 'package:shopapp/routes.dart';
import 'package:shopapp/screens/mainscreen.dart';

//this is a test
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(RatingAdapter());
  await Hive.openBox<Product>('products');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: DataProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,

          home: MainScreen(),
          // home: UserData().getuserLog ? MainPage() : AuthScreen(),
          routes: routes,

          // home: MyHomePage(title:'Flutter Demo Home Page'),
        );
      },
    );
  }
}
