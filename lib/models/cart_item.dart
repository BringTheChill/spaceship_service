import 'package:spaceship_service/models/product.dart';

class CartItem {
  Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}
