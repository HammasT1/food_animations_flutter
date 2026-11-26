import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The shopping cart: dishes in the order they were added.
class CartNotifier extends StateNotifier<List<CartLine>> {
  CartNotifier() : super(const []);

  bool contains(Recipe recipe) => state.any((l) => l.recipe.id == recipe.id);

  /// Adds [recipe], or bumps its quantity if it's already in the cart.
  void add(Recipe recipe, {int quantity = 1}) {
    final i = state.indexWhere((l) => l.recipe.id == recipe.id);
    if (i == -1) {
      state = [...state, CartLine(recipe: recipe, quantity: quantity)];
    } else {
      setQuantity(recipe, state[i].quantity + quantity);
    }
  }

  /// Sets a dish's quantity; zero removes it from the cart.
  void setQuantity(Recipe recipe, int quantity) {
    state = [
      for (final l in state)
        if (l.recipe.id != recipe.id)
          l
        else if (quantity > 0)
          l.copyWith(quantity: quantity),
    ];
  }

  void clear() => state = const [];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartLine>>(
    (ref) => CartNotifier());

/// Total number of items (sum of quantities) — what the badge shows.
final cartCountProvider = Provider<int>(
    (ref) => ref.watch(cartProvider).fold(0, (n, l) => n + l.quantity));
