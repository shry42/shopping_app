import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techsevin/controllers/cart_controller.dart';
import 'package:techsevin/database/cart_database.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.put(CartController());
  final CartDatabase _cartDatabase = CartDatabase.instance;
  @override
  void initState() {
    super.initState();
  }

/*

if (_cartController.products.isEmpty) {
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No items in the cart',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: _cartController.products.length,
          itemBuilder: (context, index) {
            // return Obx(
            //   () => cartItemCard(
            //     product: _cartController.products[index],
            //   ),
            // );
            return Obx(() => Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_cartController.products[index].title),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    _cartController.products[index].description,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  (_cartController.products[index].price *
                                          _cartController
                                              .products[index].quantity.value)
                                      .toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    _cartController.decrement(
                                        _cartController.products[index].id);
                                  },
                                ),
                                Obx(
                                  () => Text(
                                    _cartController
                                        .products[index].quantity.value
                                        .toString(),
                                    // _cartController.count.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    _cartController.increment(
                                        _cartController.products[index].id);
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                _cartDatabase
                                    .delete(_cartController.products[index].id)
                                    .then((value) {
                                  _cartController.removeProduct(
                                      _cartController.products[index].id);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
