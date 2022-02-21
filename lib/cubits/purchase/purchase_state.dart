part of 'purchase_cubit.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial();

  @override
  List<Object> get props => [];
}

class PurchaseStarted extends PurchaseState {
  const PurchaseStarted();

  @override
  List<Object> get props => [];
}

class PurchaseProcessing extends PurchaseState {
  final Payment payment;

  const PurchaseProcessing(this.payment);

  @override
  List<Object> get props => [payment];
}

class PurchaseVerifying extends PurchaseState {
  final Payment payment;

  const PurchaseVerifying(this.payment);

  @override
  List<Object> get props => [payment];
}

class PurchaseCompleted extends PurchaseState {
  final Payment payment;

  const PurchaseCompleted(this.payment);

  @override
  List<Object> get props => [payment];
}
