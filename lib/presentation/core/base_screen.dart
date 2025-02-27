import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider_registry.dart';

/// An abstract base class for all screens in the application
/// Enforces a consistent pattern for screen implementation
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);
}

/// Base state class for screens that enforces a consistent structure
abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  /// Get the screen type for provider resolution
  ScreenType get screenType;

  /// Get any additional data needed for provider resolution
  Map<String, dynamic> get providerData => {};

  /// The main build method that child classes should implement
  Widget buildScreen(BuildContext context);

  /// Helper method to determine if we need to wrap with providers
  bool get shouldWrapWithProviders => true;

  @override
  Widget build(BuildContext context) {
    // If we don't need to wrap with providers, just build the screen
    if (!shouldWrapWithProviders) {
      return buildScreen(context);
    }

    // Otherwise, wrap with the appropriate providers
    String? productId;
    if (providerData.containsKey('productId')) {
      productId = providerData['productId'] as String;
    }

    return ProviderRegistry.wrapWithProviders(
      child: buildScreen(context),
      context: context,
      screenType: screenType,
      productId: productId,
    );
  }

  /// Safely access a provider without listening to changes
  T getProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  /// Standard error handling method
  void handleError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }

  /// Navigate back helper
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
