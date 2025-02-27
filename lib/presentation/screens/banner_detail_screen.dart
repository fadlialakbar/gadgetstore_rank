import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/banner.dart' as app_banner;
import '../providers/banner_provider.dart';

class BannerDetailScreen extends StatefulWidget {
  final String bannerId;

  const BannerDetailScreen({super.key, required this.bannerId});

  @override
  State<BannerDetailScreen> createState() => _BannerDetailScreenState();
}

class _BannerDetailScreenState extends State<BannerDetailScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Ensure banners are loaded when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerData();
    });
  }

  Future<void> _loadBannerData() async {
    if (!mounted) return;

    final provider = context.read<BannerProvider>();

    // Print debug info
    debugPrint('Trying to load banner with ID: ${widget.bannerId}');
    debugPrint('Current activeBanners count: ${provider.activeBanners.length}');
    debugPrint('Current banners count: ${provider.banners.length}');

    // Load both banner lists to maximize our chances of finding the banner
    await provider.loadBanners();
    await provider.loadActiveBanners();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BannerProvider>(
        builder: (context, bannerProvider, child) {
          // Show loading indicator if banners are still loading
          if (bannerProvider.isLoading || !_isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there's an error
          if (bannerProvider.error != null) {
            return Center(
              child: Text(
                bannerProvider.error ?? 'Error loading banner',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          debugPrint(
            'After loading, activeBanners: ${bannerProvider.activeBanners.length}',
          );
          debugPrint(
            'After loading, banners: ${bannerProvider.banners.length}',
          );

          if (bannerProvider.activeBanners.isEmpty &&
              bannerProvider.banners.isEmpty) {
            debugPrint('No banners available in either list');
          }

          // Try to find the banner in activeBanners first
          app_banner.Banner? banner;

          // Try to find in activeBanners
          if (bannerProvider.activeBanners.isNotEmpty) {
            try {
              banner = bannerProvider.activeBanners.firstWhere(
                (b) => b.id == widget.bannerId,
              );
            } catch (e) {
              debugPrint('Banner not found in activeBanners');
            }
          }

          // If not found in activeBanners, try in regular banners
          if (banner == null && bannerProvider.banners.isNotEmpty) {
            try {
              banner = bannerProvider.banners.firstWhere(
                (b) => b.id == widget.bannerId,
              );
            } catch (e) {
              debugPrint('Banner not found in banners');
            }
          }

          // Handle case where banner is not found
          if (banner == null) {
            // Try one more reload if needed
            if (!bannerProvider.isLoading) {
              debugPrint('Banner not found, triggering reload');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadBannerData();
              });
            }

            // Log all available banner IDs for debugging
            debugPrint(
              'Available banner IDs in activeBanners: ${bannerProvider.activeBanners.map((b) => b.id).join(', ')}',
            );
            debugPrint(
              'Available banner IDs in banners: ${bannerProvider.banners.map((b) => b.id).join(', ')}',
            );
            debugPrint('Looking for banner ID: ${widget.bannerId}');

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Banner not found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(banner.imageUrl, fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildDateInfo(context, banner),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, app_banner.Banner banner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Period',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text(
              '${_formatDate(banner.startDate)} - ${_formatDate(banner.endDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
