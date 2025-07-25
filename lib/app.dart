import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';
import 'package:remi_kacha/core/utils/navigation_service.dart';
import 'package:remi_kacha/features/auth/presentation/registeration/profile_screen.dart';
import 'package:remi_kacha/features/auth/provider/login/auth_provider.dart';
import 'package:remi_kacha/features/onboarding/provider/onboarding_provider.dart';
import 'package:remi_kacha/features/auth/presentation/login/login_screen.dart';
import 'package:remi_kacha/features/onboarding/presentation/onboarding_screen.dart';
import 'package:remi_kacha/features/auth/presentation/pin_screen.dart';
import 'features/exchnage/provider/exchange_provider.dart';
import 'features/send_money/provider/transaction_submit_provider.dart';
import 'features/wallet/presentation/home_screen.dart';


class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  Timer? _backgroundTimer;
  bool _shouldLock = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
       final authState = ref.watch(authProvider);
       final user = authState.user;
       final isAuthenticated = authState.isAuthenticated &&
           user != null &&
           user.pin.isNotEmpty;
       if (state == AppLifecycleState.paused) {
         _backgroundTimer?.cancel();
         _backgroundTimer = Timer(const Duration(seconds: 5), () {
           _shouldLock = true;
         });
       }
    else if (state == AppLifecycleState.resumed ) {
         _backgroundTimer?.cancel();
      if(_shouldLock&&isAuthenticated){
        _shouldLock = false;
        NavigationService.push(
            CustomPinLockScreen(
              pinLength: 4,
              correctPin: user.pin,
              onPinMatched: (String pin) {
                NavigationService.push(HomeScreen());
              },
              filledDotColor: AppColors.primary,
              emptyDotColor: Colors.grey,
              errorDotColor: AppColors.error,
              dotShape: BoxShape.circle,
            ));
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingDone = ref.watch(onboardingProvider);
    ref.listen(authProvider, (previous, next) async{
      final isAuthenticated = next.isAuthenticated && next.user != null;
      if (isAuthenticated) {
       final user = next.user!;
       if(next.user!.pin.isEmpty){
         NavigationService.push(ProfileScreen(userId: next.user!.id));
       }
       else{
         final exchangeNotifier = ref.read(exchangeNotifierProvider.notifier);
           exchangeNotifier.fetchAndInsertExchangeRates();
           exchangeNotifier.fetchAllExchangeRates();
          ref.read(transactionProvider(user));
         NavigationService.push(HomeScreen());
       }
      }
    });

    if (!onboardingDone) {
      return OnboardingScreen(
        onFinish: () => ref.read(onboardingProvider.notifier).complete(),
      );
    }
    return LoginScreen();
  }
}
