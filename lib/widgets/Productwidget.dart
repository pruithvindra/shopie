import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/models/ProductModel.dart';

import 'package:shopapp/providers/repo.dart';
import 'package:shopapp/providers/themeprovider.dart';
import 'package:shopapp/screens/descriptionscreen.dart';

import '../style.dart';

class Dummy extends StatelessWidget {
  const Dummy({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return ProductTile(width: width);
  }
}

class ProductTile extends StatelessWidget {
  ProductTile({
    Key? key,
    this.product,
    required this.width,
  }) : super(key: key);

  Product? product;
  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final themeProvider = Provider.of<ThemeProvider>(context);

    // showbottomsheet() {
    //   showModalBottomSheet(
    //       shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    //       context: context,
    //       builder: (context) {
    //         return ClipRRect(
    //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //           child: DescriptionScreen(),
    //         );
    //       });
    // }

    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: themeProvider.isDarkMode
            ? [
                //background color of box
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 0.1, //extend the shadow
                  offset: Offset(
                    1.0, // Move to right 10  horizontally
                    0.0, // Move to bottom 10 Vertically
                  ),
                )
              ]
            : null,
        gradient: themeProvider.isDarkMode
            ? LinearGradient(
                stops: [
                  0.15,
                  0.40,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF3d3842),
                  Color(0xFF1a1a19),
                ],
              )
            : null,
        color: themeProvider.isDarkMode
            ? Colors.black
            : product!.id % 2 == 0
                ? Colors.redAccent.withOpacity(0.1)
                : Colors.blueAccent.withOpacity(0.1),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                context: context,
                builder: (_) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: DescriptionScreen(
                      product: product,
                    ),
                  );
                });

            // Navigator.pushNamed(context, DescriptionScreen.routename,
            //     arguments: product);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      width: width * 0.3,
                      imageUrl: poster_path(product!.image)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          product!.title,
                          // softWrap: true,
                          // wrapWords: true,
                          maxLines: 1, overflow: TextOverflow.ellipsis,

                          style: Style.display3.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxFontSize: 20,
                          minFontSize: 20,
                        ),
                        AutoSizeText("Category: ${product!.category}",
                            style: Style.display1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.stars),
                                AutoSizeText(product!.rating.rate.toString(),
                                    style: Style.display2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.people),
                                AutoSizeText(product!.rating.count.toString(),
                                    style: Style.display2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.attach_money),
                                AutoSizeText(product!.price.toString(),
                                    style: Style.display2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: Provider.of<DataProvider>(context,
                                          listen: true)
                                      .cartlist
                                      .contains(product)
                                  ? null
                                  : () {
                                      print('added');
                                      Provider.of<DataProvider>(context,
                                              listen: false)
                                          .addtocart(product);
                                    },
                              icon: Icon(Icons.shopping_cart_outlined),
                              label: AutoSizeText("Add to cart",
                                  style: Style.display2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            )
                          ],
                        ),

                        // AutoSizeText(product.price.toString(),
                        //     style: Style.display3.copyWith(
                        //         fontWeight: FontWeight.bold, fontSize: 25)),
                        // AutoSizeText(
                        //   product.description,
                        //   style: Style.display2,
                        //   maxLines: 3,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxFontSize: 20,
                        //   minFontSize: 15,
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
