import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../widgets/product_list_item.dart';
import '../../domain/entities/product.dart';
import '../../core/util/constants.dart';
import '../../core/config/router.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      if (productProvider.products.isEmpty) {
        productProvider.getAllProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoryTitle),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading ||
              productProvider.status == ProductLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productProvider.errorMessage ?? l10n.errorLoadingData,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ElevatedButton(
                    onPressed: () => productProvider.getAllProducts(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          final categories = _getUniqueCategories(productProvider.products);

          if (categories.isEmpty) {
            return Center(child: Text(l10n.noProductsAvailable));
          }

          return _buildCategoryList(categories, productProvider);
        },
      ),
    );
  }

  List<String> _getUniqueCategories(List<Product> products) {
    final categories =
        products.map((product) => product.category).toSet().toList();
    categories.sort();
    return categories;
  }

  Widget _buildCategoryList(
    List<String> categories,
    ProductProvider productProvider,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategorySection(category, productProvider);
      },
    );
  }

  Widget _buildCategorySection(
    String category,
    ProductProvider productProvider,
  ) {
    final productsInCategory = productProvider.getProductsByCategory(category);
    final isExpanded = _expandedCategories[category] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.defaultPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    '${productsInCategory.length} items',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        _expandedCategories[category] = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isExpanded)
          SizedBox(
            height: 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productsInCategory.length,
              itemBuilder: (context, index) {
                return _buildHorizontalProductItem(
                  productsInCategory[index],
                  index + 1,
                );
              },
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productsInCategory.length,
            itemBuilder: (context, index) {
              return ProductListItem(
                product: productsInCategory[index],
                rank: index + 1,
              );
            },
          ),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildHorizontalProductItem(Product product, int rank) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: AppConstants.defaultPadding),
      child: InkWell(
        onTap: () => context.push('${AppRoutes.productDetail}/${product.id}'),
        child: Card(
          color: Theme.of(context).colorScheme.background,
          elevation: AppConstants.defaultElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.defaultBorderRadius),
                  topRight: Radius.circular(AppConstants.defaultBorderRadius),
                ),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child:
                      product.imageUrls.isNotEmpty
                          ? Image.asset(
                            product.imageUrls.first,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: AppConstants.defaultFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: AppConstants.smallIconSize,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: AppConstants.smallFontSize,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(
                            fontSize: AppConstants.smallFontSize,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
