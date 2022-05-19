enum PaymentStatus {
  /// Payment is completed
  completed,

  /// Payment errored out
  error,

  /// Payment is not yet complete
  reserved,

  // User has not approved the purchase
  awaitingPayment,

  // User has rejected payment
  rejectedPayment,

  awaitingCompletionAfterRetry,
}
