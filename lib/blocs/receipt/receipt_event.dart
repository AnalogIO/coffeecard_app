part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();
  @override
  List<Object> get props => [];
}

class ReloadReceipts extends ReceiptEvent {}

class DisplayPurchases extends ReceiptEvent {}

class DisplayUsedTicket extends ReceiptEvent {}

class DisplayAll extends ReceiptEvent {}
