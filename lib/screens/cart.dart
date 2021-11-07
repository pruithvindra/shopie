import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopapp/components/formWidget.dart';
import 'package:shopapp/components/themebutton.dart';
import 'package:shopapp/models/ProductModel.dart';
import 'package:shopapp/providers/repo.dart';
import 'package:shopapp/providers/themeprovider.dart';
import 'package:shopapp/style.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  bool istap = false;
  var repository;
  void initState() {
    repository = Provider.of<DataProvider>(context, listen: false);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // TODO: implement initState
  }

  void ontap() {
    setState(() {
      istap = true;
    });
  }

  var searchmovies = [];

  searchf(value) {
    searchmovies = [];
    searchval = value;

    var movies = repository.topratedMovies.results;

    movies!.forEach((element) {
      element.title.toLowerCase().contains(searchval)
          ? searchmovies.add(element)
          : null;
    });
    print('the len is ${searchmovies.length}');
    print(searchval);
    setState(() {});
  }

  var options = {
    'key': 'rzp_test_rx1CPPgDuNkrKM',
    'amount': 100,
    'name': 'ShopApp',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
  };

  var searchval = null;

  final _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

    print("_handlePaymentSuccess payment is success ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("_handlePaymentError payment is failed ${response.message} ");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return RefreshIndicator(
      onRefresh: () async {
        return repository.getdata();
      },
      child: Consumer<DataProvider>(builder: (context, data, _) {
        var total = 0.0;
        data.cartlist.forEach((element) {
          total += element.price * element.quantity.toDouble();
          total.round();
        });
        List cartlist = data.cartlist;
        return Container(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Cart  ',
                        style: Style.display3.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            letterSpacing: 2)),
                    Icon(Icons.shopping_cart)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    child: Column(
                        children: List.generate(cartlist.length, (index) {
                  Product item = cartlist[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: themeProvider.isDarkMode
                          ? Colors.black
                          : item.id % 2 == 0
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.blueAccent.withOpacity(0.1),
                      leading: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 30,
                          child: CachedNetworkImage(
                              width: 30, imageUrl: poster_path(item.image)),
                        ),
                      ),
                      title: AutoSizeText(item.title,
                          style: Style.display2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Container(
                        margin: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.attach_money),
                                AutoSizeText(
                                    "${item.price.toString()}x${item.quantity} = ${item.price * item.quantity}",
                                    style: Style.display2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(5),
                              child: IconButton(
                                  onPressed: () {
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .removerproduct(item);

                                    // Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }))),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: themeProvider.isDarkMode
                        ? const LinearGradient(
                            stops: [
                              0.18,
                              0.43,
                              0.81,
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF222020),
                              Color(0xFF070731),
                              Color(0xFF1b0808),
                            ],
                          )
                        : const LinearGradient(
                            stops: [
                              0.18,
                              0.50,
                              0.86,
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFFde5454),
                              Color(0xFF1a6aea),
                              Color(0xFF4ddba4),
                            ],
                          ),
                    // color: themeProvider.isDarkMode
                    //     ? Colors.black
                    //     : Colors.blueAccent.withOpacity(0),
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(10))),
                height: 100,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(' Total : ${total.toStringAsFixed(2)}',
                            style: Style.display3.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                letterSpacing: 2)),
                        Icon(Icons.attach_money),
                      ],
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        onSurface: Colors.white,
                        shadowColor: Colors.white,
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        options = {
                          'key': 'rzp_test_rx1CPPgDuNkrKM',
                          'amount': 100 * total,
                          'name': 'ShopApp',
                          'description': 'Fine T-Shirt',
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com'
                          }
                        };
                        _razorpay.open(options);
                      },
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: AutoSizeText("BUY NOW",
                          style: Style.display3.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
