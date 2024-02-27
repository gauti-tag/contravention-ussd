module Mmgg
  class CoreService
    include HttpService
    include CoreApiToken
    include ActiveModel::Validations

    attr_reader :params

    def call
      process
    end

    class << self
      def call(params:)
        service = new(params: params)
        service.process
      end
    end
  
    protected
  
    def process
      http_post(endpoint, { request: params }, request_headers)
    end
  
    def endpoint
      ""
    end


    def request_headers
      { 'Content-Type': 'application/json', 'Authorization' => "Bearer #{auth_token}" }
    end


    def initialize(params:)
      @params = params
    end

  end
end