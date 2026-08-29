import 'package:device_preview/device_preview.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/checkout/presentation/screens/checkout_screen.dart';
import 'package:dribbble_challenge/src/checkout/presentation/screens/payment_method_screen.dart';
import 'package:dribbble_challenge/src/core/animation/page_transition.dart';
import 'package:dribbble_challenge/src/core/theme/app_theme.dart';
import 'package:dribbble_challenge/src/onboarding/onboarding_screen.dart';
import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:dribbble_challenge/src/recipes/presentation/screens/home_screen.dart';
import 'package:dribbble_challenge/src/recipes/presentation/screens/recipe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: DribbleChallenge()));
  // runApp(DevicePreview(
  //     enabled: true,
  //     builder: (context) {
  //       return const ProviderScope(child: DribbleChallenge());
  //     }));
}

class DribbleChallenge extends StatelessWidget {
  const DribbleChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      home: const OnBoardingScreen(),
      onGenerateRoute: (settings) {
        return switch (settings.name) {
          'home' => NoAnimationTransition(
              routeSettings: settings,
              builder: (context) => const HomeScreen(),
            ),
          'recipe_details' => NoAnimationTransition(
              routeSettings: settings,
              builder: (context) =>
                  RecipeDetailsScreen(recipe: settings.arguments as Recipe),
            ),
          'checkout' => SlideUpRoute(
              settings: settings,
              builder: (context) =>
                  CheckoutScreen(recipe: settings.arguments as Recipe),
            ),
          'payment_method' => SharedAxisRoute(
              settings: settings,
              builder: (context) => PaymentMethodScreen(
                  order: settings.arguments as OrderDraft),
            ),
          _ => NoAnimationTransition(
              routeSettings: settings,
              builder: (context) => const HomeScreen())
        };
      },
      theme: mainTheme,
      darkTheme: mainTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
//a
