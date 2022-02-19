import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/buy_one_drink_page/buy_one_drink_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyOneDrinkPage extends StatefulWidget {
  const BuyOneDrinkPage({Key? key}) : super(key: key);

  @override
  _BuyOneDrinkPageState createState() => _BuyOneDrinkPageState();
}

class _BuyOneDrinkPageState extends State<BuyOneDrinkPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyOneDrinkCubit(),
      child: AppScaffold(
        title: Strings.buyOneDrinkPageTitle,
        body: BlocBuilder<BuyOneDrinkCubit, BuyOneDrinkState>(
          builder: (context, state) {
            if (state is BuyOneDrinkLoading) {
              final BuyOneDrinkCubit buyOneDrinkCubit =
                  context.read<BuyOneDrinkCubit>();
              buyOneDrinkCubit.getTickets();
              //FIXME: handle loading
              return const Text('loading');
            } else if (state is BuyOneDrinkLoaded) {
              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: state.products,
              );
            } else if (state is BuyOneDrinkError) {
              //FIXME: display error properly
              return const Text('error');
            }
            //FIXME: provide meaningfull error, maybe pass widget name?
            throw MatchCaseIncompleteException('match cases incomplete');
          },
        ),
      ),
    );
  }
}
