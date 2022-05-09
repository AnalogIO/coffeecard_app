import 'package:coffeecard/cubits/contributor/contributor_cubit.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/contributor_card.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContributorPage extends StatelessWidget {
  static Route get route =>
      MaterialPageRoute(builder: (_) => ContributorPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: 'Contributors',
      body: BlocProvider(
        create: (context) => ContributorCubit(sl.get<ContributorRepository>())
          ..getContributors(),
        child: BlocBuilder<ContributorCubit, ContributorState>(
          builder: (context, state) {
            if (state is ContributorLoading) {
              return const CircularProgressIndicator();
            } else if (state is ContributorLoaded) {
              return ListView(
                children:
                    state.contributors.map((e) => ContributorCard(e)).toList(),
              );
            } else if (state is ContributorError) {
              return ErrorSection(
                center: true,
                error: state.error,
                retry: context.read<ContributorCubit>().getContributors,
              );
            }

            throw MatchCaseIncompleteException(this);
          },
        ),
      ),
    );
  }
}
