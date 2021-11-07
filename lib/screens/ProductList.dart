import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/components/formWidget.dart';
import 'package:shopapp/components/themebutton.dart';
import 'package:shopapp/models/ProductModel.dart';

import 'package:shopapp/providers/repo.dart';

import 'package:shopapp/style.dart';
import 'package:shopapp/widgets/Productwidget.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({Key? key}) : super(key: key);

  @override
  _NowplayingScreenState createState() => _NowplayingScreenState();
}

class _NowplayingScreenState extends State<ProductListScreen> {
  @override
  bool istap = false;
  var repository;
  void initState() {
    repository = Provider.of<DataProvider>(context, listen: false);
    // TODO: implement initState
  }

  void ontap() {
    setState(() {
      istap = true;
    });
  }

  var searchproducts = [];
  searchf(value) {
    addf(element) {
      searchproducts.add(element);
    }

    print(Provider.of<DataProvider>(context, listen: false).productlist.length);
    searchproducts = [];
    searchval = value;
    Provider.of<DataProvider>(context, listen: false)
        .productlist
        .forEach((element) {
      String title = element.title;
      title.toLowerCase().startsWith(searchval) ? addf(element) : null;
    });

    setState(() {});
  }

  var searchval = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return RefreshIndicator(
      onRefresh: () async {
        return repository.getdata();
      },
      child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Collections  ',
                    style: Style.display3.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 2)),
                Icon(Icons.auto_awesome_sharp)
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('The best Deals, all at one place',
                    style: Style.display1
                        .copyWith(fontSize: 20, color: Colors.grey)),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FormWIdget(
                    hintText: 'search',
                    sufixicon: Icon(Icons.search),
                    width: width * 0.4,
                    onTap: ontap,
                    onchanged: (val) {
                      searchf(val);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ChangeThemeButtonWidget(),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                child: Consumer<DataProvider>(
                  builder: (ctx, data, _) {
                    List Productslist = data.productlist;
                    // return Container();
                    return !data.isfetched
                        ? ValueListenableBuilder<Box<Product>>(
                            valueListenable:
                                Hive.box<Product>('products').listenable(),
                            builder: (context, box, _) {
                              print('fromlocal');

                              final productslist =
                                  box.values.toList().cast<Product>().toList();

                              return box.length == 0
                                  ? Column(
                                      children: [
                                        Text("No Data to show here ",
                                            style: Style.display3.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25)),
                                        Container(
                                          height: height,
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: List.generate(
                                          productslist.length, (index) {
                                        return ProductTile(
                                          key: UniqueKey(),
                                          width: width,
                                          product: productslist[index],
                                        );
                                      }),
                                    );
                            },
                          )
                        : Productslist.length == 0 ||
                                Productslist.length == null
                            ? Column(
                                children: [
                                  Text("No Data to show",
                                      style: Style.display3.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  Container(
                                    height: height,
                                  )
                                ],
                              )
                            : searchval == '' || searchval == null
                                ? Column(
                                    children: List.generate(Productslist.length,
                                        (index) {
                                      print('fromnoloc');
                                      return ProductTile(
                                        key: UniqueKey(),
                                        width: width,
                                        product: Productslist[index],
                                      );
                                    }),
                                  )
                                : Column(
                                    children: List.generate(
                                        searchproducts.length, (index) {
                                      print('fromnoloc');
                                      return ProductTile(
                                        key: UniqueKey(),
                                        width: width,
                                        product: searchproducts[index],
                                      );
                                    }),
                                  );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  // showModalBottomSheet(
  //   context: context,
  //   builder: (context) {
  //     return
  //   })
}
