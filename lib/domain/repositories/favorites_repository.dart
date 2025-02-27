import '../entities/product.dart';

abstract class FavoritesRepository {
  /// Gets all favorite products
  Future<List<Product>> getFavorites();

  /// Adds a product to favorites
  Future<bool> addToFavorites(Product product);

  /// Removes a product from favorites
  Future<bool> removeFromFavorites(String productId);

  /// Checks if a product is in favorites
  Future<bool> isFavorite(String productId);

  /// Toggles a product's favorite status
  Future<bool> toggleFavorite(Product product);
}
