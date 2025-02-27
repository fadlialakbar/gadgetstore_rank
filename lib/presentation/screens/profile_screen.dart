import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF1ABC9C),
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.guestUser,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.signInToAccess,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              l10n.accountSettings,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            _buildProfileCard(
              context,
              icon: Icons.shopping_bag_outlined,
              title: l10n.orders,
              subtitle: l10n.viewOrderHistory,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.featureComingSoon(l10n.orders))),
                );
              },
            ),

            _buildProfileCard(
              context,
              icon: Icons.favorite_outline,
              title: l10n.wishlist,
              subtitle: l10n.savedProducts,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.featureComingSoon(l10n.wishlist)),
                  ),
                );
              },
            ),

            _buildProfileCard(
              context,
              icon: Icons.reviews_outlined,
              title: l10n.myReviews,
              subtitle: l10n.manageYourReviews,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.featureComingSoon(l10n.myReviews)),
                  ),
                );
              },
            ),

            _buildProfileCard(
              context,
              icon: Icons.notifications_outlined,
              title: l10n.notifications,
              subtitle: l10n.manageNotifications,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.featureComingSoon(l10n.notifications)),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            Text(
              l10n.appSettings,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            _buildProfileCard(
              context,
              icon: Icons.language,
              title: l10n.language,
            ),

            _buildProfileCard(
              context,
              icon: Icons.settings_outlined,
              title: l10n.settings,
              subtitle: l10n.appPreferences,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.featureComingSoon(l10n.settings)),
                  ),
                );
              },
            ),

            _buildProfileCard(
              context,
              icon: Icons.help_outline,
              title: l10n.helpSupport,
              subtitle: l10n.faqsAndSupport,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.featureComingSoon(l10n.helpSupport)),
                  ),
                );
              },
            ),

            _buildProfileCard(
              context,
              icon: Icons.info_outline,
              title: l10n.about,
              subtitle: l10n.aboutAppVersion,
              onTap: () {
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AboutDialog(
            applicationName: 'App',
            applicationVersion: 'v1.0.0',
            applicationIcon: Image.asset(
              'assets/images/app_icon.png',
              width: 50,
              height: 50,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.devices,
                    size: 50,
                    color: Color(0xFF1ABC9C),
                  ),
            ),
            children: [
              const SizedBox(height: 16),
              Text(l10n.aboutDescription),
              const SizedBox(height: 16),
              const Text('© 2025 App. All rights reserved.'),
            ],
          ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.onBackground),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        subtitleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onTap: onTap,
      ),
    );
  }
}
