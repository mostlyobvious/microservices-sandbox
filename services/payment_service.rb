require 'ms/application'
require 'ms/event'
require 'securerandom'
require 'dependor'
require 'dependor/shorty'


Payment = Struct.new(:id, :order_id, :amount, :payment_method, :transaction_id)

class PaymentGateway
  PaymentError = Class.new(StandardError)

  def authorize(payment)
    raise PaymentError.new if SecureRandom.random_number < 0.1
    SecureRandom.uuid
  end

end

class PaymentRepository

  def initialize
    @store = Hash.new
  end

  def insert(payment)
    @store[payment.id] = payment
  end

end

class OrderPaymentUsecase

  takes :payment_gateway, :payment_repository

  def call(order_accepted_event)
    #order   = order_accepted_event.order
    #payment = Payment.new(order.id, order.total_price, order.payment_method)
    payment = Payment.new
    payment.transaction_id = payment_gateway.authorize(payment)
    #[PaymentAcceptedEvent.new(payment)]
    [payment_accepted_event]
  rescue PaymentGateway::PaymentError
    #[PaymentFailedEvent.new(payment)]
    [payment_failed_event]
  end

  protected

  def payment_failed_event
    MS::Event.new(SecureRandom.uuid, Time.new.utc, :payment_failed)
  end

  def payment_accepted_event
    MS::Event.new(SecureRandom.uuid, Time.new.utc, :payment_accepted)
  end

end

class PaymentService

  takes :payment_usecase

  def run
    application = MS::Application.new
    application.events do |ev|
      ev.match :order_accepted, payment_usecase
    end
    application.run
  end

end

microservice = PaymentService.new(OrderPaymentUsecase.new(PaymentGateway.new, PaymentRepository.new))
microservice.run


