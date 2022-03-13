enum PaymentStatus {
  completed, //payment is completed
  error, //payment errored out
  reserved, //payment is not yet complete
  awaitingPayment, //user has not approved the purchase
  rejectedPayment, //user has rejected payment
  awaitingCompletionAfterRetry
}
