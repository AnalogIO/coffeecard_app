import 'package:coffeecard/core/widgets/pages/splash/splash_loading_page.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeLoader extends StatefulWidget {
  @override
  State<HomeLoader> createState() => _HomeLoaderState();
}

class _HomeLoaderState extends State<HomeLoader> {
  @override
  void initState() {
    super.initState();
    _loadUserAndProducts();
  }

  Future<void> _loadUserAndProducts() async {
    final userCubit = context.read<UserCubit>();
    final productCubit = context.read<ProductCubit>();

    try {
      await Future.wait([
        userCubit.initialize(),
        productCubit.getProducts(),
      ]);

      final userLoaded = userCubit.state is UserInitiallyLoaded;
      final productState = productCubit.state;

      if (userLoaded && productState is ProductsLoaded) {
        // Navigate to actual home page with products
        context.go('/home');
      } else {
        // Handle loading failure
        context.read<AuthenticationCubit>().unauthenticated();
        context.go('/login');
      }
    } catch (e) {
      context.go('/error', extra: 'Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashLoadingPage(); // Show loading while we fetch data
  }
}
