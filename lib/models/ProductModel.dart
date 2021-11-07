import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'ProductModel.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image,
      required this.rating,
      this.quantity});

  @HiveField(0)
  late final int id;

  @HiveField(1)
  late final String title;
  @HiveField(2)
  int? quantity = 1;
  @HiveField(3)
  late final price;
  @HiveField(4)
  late final String description;
  @HiveField(5)
  late final String category;
  @HiveField(6)
  late final String image;
  @HiveField(7)
  late final Rating rating;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = Rating.fromJson(json['rating']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['price'] = price;
    _data['description'] = description;
    _data['category'] = category;
    _data['image'] = image;
    _data['rating'] = rating.toJson();
    return _data;
  }
}

// class Rating {
//   Rating({
//     required this.rate,
//     required this.count,
//   });

//   late final rate;

//   late final int count;

//   Rating.fromJson(Map<String, dynamic> json) {
//     rate = json['rate'];
//     count = json['count'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['rate'] = rate;
//     _data['count'] = count;
//     return _data;
//   }
// }

@HiveType(typeId: 1)
class Rating {
  Rating({
    required this.rate,
    required this.count,
  });
  @HiveField(0)
  late final rate;
  @HiveField(1)
  late final int count;

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rate'] = rate;
    _data['count'] = count;
    return _data;
  }
}
