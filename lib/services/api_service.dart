import 'dart:convert';
import 'dart:developer';

import "package:http/http.dart" as http;
import 'package:techsevin/database/product_database.dart';
import 'package:techsevin/models/product.dart';
import 'package:techsevin/utils/urls.dart';

class ApiService {
  static final productDatabase = ProductDatabase.instance;
  static Future<List<Product>?> getProducts() async {
    List<Product> products = await productDatabase.getAllProducts();
    if (products.isNotEmpty) {
      log(">> products loaded from sqlflite db!!!");
      _updateProducts();
      return products;
    } else {
      http.Response response = await http.get(Uri.parse(Urls.getProducts));

      if (response.statusCode == 200) {
        List listOfMap = jsonDecode(response.body)[
            'products']; //the data is already in list, so storing it in list

        //creating a empty list of model as a object
        List<Product> listOfObjProduct = [];

        for (int i = 0; i < listOfMap.length; i++) {
          Product? at = Product.fromJson(listOfMap[i]);
          listOfObjProduct.add(at);
        }
        for (Product product in listOfObjProduct) {
          productDatabase.insert(product);
        }
        log(">> products loaded from api!!!");
        return listOfObjProduct;
      } else {
        return null;
      }
    }
  }

  static Future<void> _updateProducts() async {
    http.Response response = await http.get(Uri.parse(Urls.getProducts));
    if (response.statusCode == 200) {
      List listOfMap = jsonDecode(response.body)[
          'products']; //the data is already in list, so storing it in list

      //creating a empty list of model as a object
      List<Product> listOfObjProduct = [];

      for (int i = 0; i < listOfMap.length; i++) {
        Product? at = Product.fromJson(listOfMap[i]);
        listOfObjProduct.add(at);
      }
      for (Product product in listOfObjProduct) {
        productDatabase.getProductById(product.id).then((value) {
          // log(">> fetched product : ${value != null ? value.toSQLJson() : ""}");
          if (value != null) {
            productDatabase.update(product);
            log(">> updated product : ${product.id}");
          } else {
            productDatabase.insert(product);
            log(">> added product : ${product.id}");
          }
        });
      }
    }
  }
}
