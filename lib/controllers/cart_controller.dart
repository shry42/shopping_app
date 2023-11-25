import 'package:get/get.dart';
import 'package:techsevin/database/cart_database.dart';
import 'package:techsevin/models/product.dart';

class CartController extends GetxController {
  CartDatabase cartDatabase = CartDatabase.instance;
  @override
  void onInit() async {
    super.onInit();
    products = await cartDatabase.getAllProducts();
  }

  RxList<Product> products = <Product>[].obs;

  void increment(int id) {
    int index = products.indexWhere((product) => product.id == id);
    if (index != -1) {
      products[index].quantity.value = products[index].quantity.value + 1;
    }
  }

  void decrement(int id) {
    int index = products.indexWhere((pd) => pd.id == id);
    if (index != -1 && products[index].quantity.value != 0) {
      products[index].quantity.value = products[index].quantity.value - 1;
    }
  }

  void addProduct(Product product) {
    products.add(product);
  }

  void removeProduct(int id) {
    products.removeWhere((element) => element.id == id);
  }
}
