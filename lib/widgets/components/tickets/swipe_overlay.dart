import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/widgets/components/tickets/slide_button.dart';
import 'package:flutter/cupertino.dart';

class SwipeOverlay extends StatelessWidget {
  final String title;
  final int productId;
  final TicketsCubit ticketsCubit;

  const SwipeOverlay({
    Key? key,
    required this.title,
    required this.productId,
    required this.ticketsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            SlideButton(
              width: MediaQuery.of(context).size.width * 0.9,
              onSwipeComplete: () {
                ticketsCubit.useTicket(productId);
              },
            )
          ],
        ),
      ),
    );
  }
}
