import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';

/// A mutable draft of an order while the user is in the checkout flow.
class OrderDraft {
  final Recipe recipe;
  int quantity;

  OrderDraft({required this.recipe, this.quantity = 1});

  double get unitPrice => 6.0 + (recipe.nutrition['calories']! / 100);
  double get subtotal => unitPrice * quantity;
  double get deliveryFee => 2.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  /// Rough ready-in estimate, in minutes.
  int get etaMinutes => 15 + (recipe.nutrition['prepTime']?.round() ?? 20);

  String get orderId {
    final base = recipe.id.padLeft(2, '0');
    final stamp = DateTime.now().millisecondsSinceEpoch % 100000;
    return '#FD$base$stamp';
  }
}

/// Payment methods offered in the mock flow.
enum PaymentMethod {
  visa('Visa', '•••• 4291', 'assets/images/dish.png'),
  applePay('Apple Pay', 'Face ID', ''),
  paypal('PayPal', 'alex.morgan@example.com', ''),
  cash('Cash on delivery', 'Pay at the door', '');

  const PaymentMethod(this.label, this.detail, this.asset);
  final String label;
  final String detail;
  final String asset;
}
