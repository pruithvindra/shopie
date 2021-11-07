import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/ProductModel.dart';

class DataProvider with ChangeNotifier {
  var _Productsurl = 'https://fakestoreapi.com/products';

  List productlist = [];
  List cartlist = [];
  bool isfetched = false;
  // NowPlaying nowPlaying = NowPlaying(results: []);
  // TopratedMovies topratedMovies = TopratedMovies();

  addtocart(product) {
    cartlist.add(product);
    notifyListeners();
  }

  addquant(var id) {
    Product product = cartlist.firstWhere((element) => element.id == id);

    product.quantity! >= 1
        ? cartlist.singleWhere((element) => element.id == id).quantity++
        : null;
    print(product.quantity);
    print('g2');
    notifyListeners();
  }

  removequant(var id) {
    Product product = cartlist.firstWhere((element) => element.id == id);

    product.quantity! > 1
        ? cartlist.singleWhere((element) => element.id == id).quantity--
        : null;
    print(product.quantity);
    print('g2');
    notifyListeners();
  }

  removerproduct(Product product) {
    cartlist.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }

  Future getdata() async {
    productlist = [];
    print('fetchiing');
    try {
      var response = await http.get(Uri.parse(_Productsurl));

      List data = jsonDecode(response.body);

      data.forEach((element) {
        print('jihh');
        Product product = Product.fromJson(element);

        productlist.add(product);

        Hive.box<Product>('products').put(product.id, product);
      });
      isfetched = true;
      notifyListeners();
      print(productlist.length);
    } on Exception catch (e) {
      throw e;
    }
    notifyListeners();
    // print(nowPlaying.results.length);
  }

  // removedata(MovieItem Movie) {
  //   nowPlaying.results.removeWhere((element) => element.id == Movie.id);

  //   topratedMovies.results!.removeWhere((element) => element.id == Movie.id);

  //   notifyListeners();
  // }
}
