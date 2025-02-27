import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/config/router.dart';
import '../../core/util/constants.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    final int selectedIndex = _getSelectedIndex(currentLocation);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.navBarBorderRadius),
            topRight: Radius.circular(AppConstants.navBarBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.navBarBorderRadius),
            topRight: Radius.circular(AppConstants.navBarBorderRadius),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) => _onItemTapped(context, index),
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            selectedFontSize: AppConstants.smallFontSize,
            unselectedFontSize: AppConstants.smallFontSize,
            iconSize: AppConstants.defaultIconSize,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'assets/icons/home.svg',
                    width: AppConstants.defaultIconSize,
                    height: AppConstants.defaultIconSize,
                  ),
                ),
                label: l10n.homeTitle,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'assets/icons/category.svg',
                    width: AppConstants.defaultIconSize,
                    height: AppConstants.defaultIconSize,
                  ),
                ),
                label: l10n.categoryTitle,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'assets/icons/community.svg',
                    width: AppConstants.defaultIconSize,
                    height: AppConstants.defaultIconSize,
                  ),
                ),
                label: l10n.communityTitle,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'assets/icons/profile.svg',
                    width: AppConstants.defaultIconSize,
                    height: AppConstants.defaultIconSize,
                  ),
                ),
                label: l10n.myPageTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(String currentLocation) {
    if (currentLocation.startsWith(AppRoutes.home)) {
      return 0;
    } else if (currentLocation.startsWith(AppRoutes.categories)) {
      return 1;
    } else if (currentLocation.startsWith(AppRoutes.community)) {
      return 2;
    } else if (currentLocation.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.categories);
        break;
      case 2:
        context.go(AppRoutes.community);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
