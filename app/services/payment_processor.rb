class PaymentProcessor
  include HttpService
  include CoreApiToken
  include ActiveModel::Validations

  class << self
    def call(params:)
      payment = new(params: params)
      response = payment.execute
      OpenStruct.new(status: 200, response: response)
    end
  end

  attr_reader :params

  def execute
    @execute ||= process
  end

  def process
    http_post(endpoint, { request: params }, request_headers)
  end

  def endpoint
    "#{ENV['CORE_ENDPOINT']}/api/ussd/payment"
  end

  def request_headers
    { 'Content-Type': 'application/json', 'Authorization' => "Bearer #{auth_token}" }
  end


  def initialize(params:)
    @params = params
  end
  

end