import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:flutter/material.dart';

/// What the tracking screen needs: the order, and the order id the success
/// screen already showed (so both screens agree on it).
class TrackingArgs {
  final OrderDraft order;
  final String orderId;
  const TrackingArgs({required this.order, required this.orderId});
}

/// The lifecycle of a delivery. [start] is where the stage begins on the
/// demo timeline (0..1 of the whole simulated delivery).
enum DeliveryStage {
  confirmed('Order confirmed', 'The restaurant accepted your order',
      Icons.receipt_long_rounded, 0.0),
  preparing('Preparing your food', 'The chef is cooking it fresh',
      Icons.soup_kitchen_rounded, 0.10),
  onTheWay('On the way', 'Your rider is heading to you',
      Icons.delivery_dining_rounded, 0.35),
  delivered('Delivered', 'Enjoy your meal!', Icons.home_rounded, 1.0);

  const DeliveryStage(this.title, this.subtitle, this.icon, this.start);
  final String title;
  final String subtitle;
  final IconData icon;
  final double start;

  /// Where the stage ends on the timeline (the next stage's start).
  double get end =>
      this == delivered ? 1.0 : DeliveryStage.values[index + 1].start;

  static DeliveryStage at(double t) {
    for (final s in DeliveryStage.values.reversed) {
      if (t >= s.start) return s;
    }
    return confirmed;
  }

  /// 0..1 progress within this stage at timeline position [t].
  double progressAt(double t) =>
      end == start ? 1 : ((t - start) / (end - start)).clamp(0.0, 1.0);
}
