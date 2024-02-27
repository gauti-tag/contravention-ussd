class ProcessPaymentJob < ApplicationJob
  queue_as :default

  def perform(data)
    # Do something later
    PaymentProcessor.call(params: data)
  end
end
