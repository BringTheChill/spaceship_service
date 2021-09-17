import 'package:spaceship_service/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => quantity * product.price;
}
