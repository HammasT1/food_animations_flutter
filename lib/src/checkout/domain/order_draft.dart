import 'dart:math' as math;

import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';

/// Menu price of a dish.
double unitPriceOf(Recipe recipe) =>
    6.0 + (recipe.nutrition['calories']! / 100);

/// One dish in the cart, with how many of it.
class CartLine {
  final Recipe recipe;
  final int quantity;
  const CartLine({required this.recipe, this.quantity = 1});

  double get unitPrice => unitPriceOf(recipe);
  double get total => unitPrice * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(recipe: recipe, quantity: quantity ?? this.quantity);
}

/// An immutable snapshot of the cart, taken when the user heads to payment.
class OrderDraft {
  final List<CartLine> lines;

  OrderDraft({required List<CartLine> lines})
      : assert(lines.isNotEmpty, 'an order needs at least one dish'),
        lines = List.unmodifiable(lines);

  OrderDraft.single(Recipe recipe, {int quantity = 1})
      : this(lines: [CartLine(recipe: recipe, quantity: quantity)]);

  /// The lead dish — drives the accent colour and imagery downstream.
  Recipe get recipe => lines.first.recipe;

  int get itemCount => lines.fold(0, (n, l) => n + l.quantity);
  double get subtotal => lines.fold(0.0, (s, l) => s + l.total);
  double get deliveryFee => 2.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  /// Rough ready-in estimate, in minutes — the slowest dish sets the pace.
  int get etaMinutes =>
      15 +
      lines
          .map((l) => l.recipe.nutrition['prepTime']?.round() ?? 20)
          .reduce(math.max);

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
