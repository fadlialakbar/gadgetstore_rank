import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/service_locator.dart' as di;
import '../providers/splash_provider.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashProvider _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<SplashProvider>();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (_viewModel.state == SplashState.success) {
      GoRouter.of(context).go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      builder: (context, _) {
        return FutureBuilder(
          future: _initOnce(context),
          builder: (context, snapshot) {
            return Consumer<SplashProvider>(
              builder: (context, viewModel, _) {
                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                          theme.colorScheme.secondary.withOpacity(0.6),
                          theme.colorScheme.tertiary.withOpacity(0.4),
                          theme.colorScheme.surface.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppLogo(size: 120),
                            Text(
                              l10n.splashTagline,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            if (viewModel.state == SplashState.initializing)
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            if (viewModel.state == SplashState.error)
                              Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: theme.colorScheme.error,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.errorLoadingData,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                    ),
                                    child: Text(
                                      viewModel.errorMessage ?? '',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed:
                                        () => _retryInitialization(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          theme.colorScheme.primary,
                                      elevation: 3,
                                    ),
                                    child: Text(l10n.retry),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  bool _hasInitialized = false;

  Future<void> _initOnce(BuildContext context) async {
    if (!_hasInitialized) {
      _hasInitialized = true;
      _viewModel.addListener(_onStateChanged);

      await Future.microtask(() {});

      _viewModel.initializeData(context);
    }
    return Future.value();
  }

  void _retryInitialization(BuildContext context) {
    _viewModel.retry(context);
  }
}
