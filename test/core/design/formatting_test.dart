import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipts_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

SwipeReceipt _swipe(DateTime time) => SwipeReceipt(
      productName: 'Espresso based',
      menuItemName: 'Cortado',
      timeUsed: time,
      id: 0,
    );

void main() {
  test('prices are shown in Danish kroner', () {
    expect(Strings.price(45), '45 Kr.');
    expect(Strings.paymentConfirmationBottomPurchase(45), 'Pay 45 Kr. with...');
  });

  test('tickets summary pluralises', () {
    expect(Strings.ticketsSummary(cards: 1, ticketsLeft: 1),
        '1 CARD · 1 TICKET LEFT');
    expect(
      Strings.ticketsSummary(cards: 2, ticketsLeft: 10),
      '2 CARDS · 10 TICKETS LEFT',
    );
  });

  group('receipts by day', () {
    final now = DateTime(2026, 11, 10, 12);

    test('labels today, yesterday and older days', () {
      expect(receiptDayLabel(DateTime(2026, 11, 10), now: now), 'TODAY');
      expect(receiptDayLabel(DateTime(2026, 11, 9), now: now), 'YESTERDAY');
      expect(receiptDayLabel(DateTime(2026, 11, 6), now: now), 'FRI 6 NOV');
      expect(
        receiptDayLabel(DateTime(2025, 11, 6), now: now),
        'THU 6 NOV 2025',
      );
    });

    test('groups consecutive receipts that share a date', () {
      final days = groupReceiptsByDay([
        _swipe(DateTime(2026, 11, 10, 9)),
        _swipe(DateTime(2026, 11, 10, 8)),
        _swipe(DateTime(2026, 11, 9, 13)),
      ]);
      expect(days.length, 2);
      expect(days.first.$2.length, 2);
      expect(days.last.$1, DateTime(2026, 11, 9));
    });
  });
}
