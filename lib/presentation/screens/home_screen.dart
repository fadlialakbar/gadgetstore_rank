import 'package:flutter/material.dart';
import 'package:gadget_rank/core/util/constants.dart';
import 'package:gadget_rank/presentation/widgets/rank_icon.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../core/animation/slide_animation.dart';
import '../../core/config/router.dart';
import '../core/base_screen.dart';
import '../core/provider_registry.dart';
import '../controllers/home_controller.dart';
import '../providers/review_provider.dart';
import '../widgets/app_logo.dart';
import '../widgets/banner_card.dart';
import '../widgets/product_list_item.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  ScreenType get screenType => ScreenType.home;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget buildScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 4.0,
        shadowColor: Theme.of(
          context,
        ).colorScheme.onBackground.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        title: const AppLogoText(),
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError) {
            return Center(
              child: Text(
                controller.errorMessage ?? l10n.errorLoadingData,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final topProducts = controller.topProducts;
          final activeBanners = controller.activeBanners;

          if (topProducts.isEmpty) {
            return Center(child: Text(l10n.errorLoadingData));
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: ListView(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.transparent),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.searchHint,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.primary,
                                size: 34,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Banners
                if (activeBanners.isNotEmpty)
                  SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _bannerController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
                          },
                          itemCount: activeBanners.length,
                          itemBuilder: (context, index) {
                            final banner = activeBanners[index];
                            return SlideAnimation(
                              delay: 0.2 * index,
                              child: BannerCard(banner: banner),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                activeBanners.asMap().entries.map((entry) {
                                  return Container(
                                    width:
                                        _currentBannerIndex == entry.key
                                            ? 16.0
                                            : 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.white.withOpacity(
                                        _currentBannerIndex == entry.key
                                            ? 1.0
                                            : 0.7,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 180,
                    child: Center(child: Text(l10n.noBannersAvailable)),
                  ),
                SizedBox(height: AppConstants.defaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.reviewRankingTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              l10n.reviewRankingSubtitle,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(AppRoutes.categories);
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConstants.defaultPadding),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: topProducts.length > 3 ? 3 : topProducts.length,
                  itemBuilder: (context, index) {
                    final product = topProducts[index];
                    final rank = product.rank != 0 ? product.rank : index + 1;
                    return ProductListItem(product: product, rank: rank);
                  },
                ),

                SizedBox(height: AppConstants.defaultPadding * 2),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.bestReviewersIntro,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.bestReviewers,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppConstants.defaultPadding),

                SizedBox(
                  height: 160,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                        Provider.of<ReviewProvider>(
                          context,
                          listen: false,
                        ).getTopReviewers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading reviewers',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        );
                      }

                      final reviewers = snapshot.data ?? [];

                      if (reviewers.isEmpty) {
                        return const Center(
                          child: Text('No reviewers available'),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: reviewers.length,
                        itemBuilder: (context, index) {
                          final reviewer = reviewers[index];
                          print(reviewer.toString());
                          return SlideAnimation(
                            delay: 0.05 * index,
                            child: GestureDetector(
                              onTap: () {
                                final reviewerId = reviewer['id'].toString();
                                final route = AppRoutes.reviewerProfile
                                    .replaceFirst(':id', reviewerId);
                                context.push(route);
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  reviewer['rank'] == 1
                                                      ? Colors.amber
                                                      : Colors.transparent,
                                              width: 3,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 36,
                                            backgroundImage: AssetImage(
                                              reviewer['imageUrl'],
                                            ),
                                          ),
                                        ),
                                        if (reviewer['rank'] == 1)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: buildRankIcon(
                                              reviewer['rank'],
                                            ),
                                          ),
                                        // Positioned(
                                        //   top: 0,
                                        //   left: 0,
                                        //   child: Image.asset(
                                        //     'assets/images/icons/crown.png',
                                        //     width: 24,
                                        //     height: 24,
                                        //     errorBuilder:
                                        //         (
                                        //           context,
                                        //           error,
                                        //           stackTrace,
                                        //         ) => const Icon(
                                        //           Icons.emoji_events,
                                        //           color: Colors.amber,
                                        //           size: 24,
                                        //         ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      reviewer['name'] ??
                                          'Name${(index + 1).toString().padLeft(2, '0')}',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppConstants.defaultPadding),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildFooterItem(context, l10n.footerAboutUs),
                          Text(
                            " | ",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          _buildFooterItem(context, l10n.footerCareers),
                          Text(
                            " | ",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          _buildFooterItem(context, l10n.footerTechBlog),
                          Text(
                            " | ",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          _buildFooterItem(context, l10n.footerReviewRights),
                        ],
                      ),
                      SizedBox(height: AppConstants.defaultPadding),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_right,
                                color: Colors.grey[700],
                                size: 32,
                              ),
                              Text(
                                l10n.footerContactEmail,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[500]!),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "KOR",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Divider(color: Colors.grey[400], height: 32),

                      Center(
                        child: Text(
                          l10n.footerCopyright,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooterItem(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
    );
  }
}
