part of 'tickets_page.dart';

class TicketSection extends StatelessWidget {
  const TicketSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketsCubit(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('My tickets', style: AppTextStyle.sectionTitle),
            ),
            BlocConsumer<TicketsCubit, TicketsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is TicketsLoading) {
                  final ticketsCubit = context.read<TicketsCubit>();
                  ticketsCubit.getTickets();
                  return const Text('loading');
                } else if (state is TicketsLoaded) {
                  return Column(
                    children: state.tickets.isEmpty
                        ? [const EmptyCoffeeCard()]
                        : state.tickets
                            .map(
                              (e) => const CoffeeCard(
                                title: 'Espresso Based',
                                amount: 8,
                              ),
                            )
                            .toList(),
                  );
                } else if (state is TicketsError) {
                  return const Text('error');
                }
                //FIXME: provide meaningfull error, maybe pass widget name?
                throw MatchCaseIncompleteException('match cases incomplete');
              },
            ),
          ],
        ),
      ),
    );
  }
}
