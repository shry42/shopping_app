import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:techsevin/controllers/cart_controller.dart';
import 'package:techsevin/database/cart_database.dart';
import 'package:techsevin/database/product_database.dart';
import 'package:techsevin/models/product.dart'; // Import your Product model
import 'package:techsevin/screens/cart_screen.dart';
import 'package:techsevin/services/api_service.dart';
import 'package:techsevin/utils/toast.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>?> _productsFuture;
  final CartController _cartController = Get.put(CartController());
  final CartDatabase _cartDatabase = CartDatabase.instance;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.getProducts();
  }

  // Function to generate star ratings widget based on the rating value
  Widget _buildStarRating(double rating) {
    int numberOfStars = rating.floor();
    List<Widget> stars = List.generate(
      numberOfStars,
      (index) => Icon(Icons.star, color: Colors.yellow),
    );

    if (rating - numberOfStars >= 0.5) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }
    // return Container();
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const CartScreen());
                },
                child: Icon(
                  Icons.shop_2,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>?>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Product>? products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 380),

                //  itemExtent: 200, // Set the custom height here (adjust as needed)

                itemCount: products.length,

                itemBuilder: (context, index) {
                  Product product = products[index];
                  double discountedPrice = product.price -
                      (product.price * product.discountPercentage / 100);

                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            product.images.isNotEmpty ? product.images[0] : '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Brand: ${product.brand}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Price: \₹${product.price.toString()}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Discounted Price: \₹${discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 4),
                              _buildStarRating(product.rating),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _cartDatabase
                                        .getProductById(product.id)
                                        .then((gotProduct) {
                                      if (gotProduct != null) {
                                        showToast("product already added..");
                                      } else {
                                        _cartDatabase
                                            .insert(product)
                                            .then((val) {
                                          _cartController.addProduct(product);
                                          showToast(
                                              "product added succesfully");
                                        });
                                      }
                                    });
                                  },
                                  child: Text('Add to Cart'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No products available'));
            }
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
