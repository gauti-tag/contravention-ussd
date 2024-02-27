module Mmgg
    class FetchTransactions < CoreService
  
      def process
        http_post(endpoint, { request: params }, request_headers)
      end
    
      def endpoint
        "#{ENV['CORE_ENDPOINT']}/api/transactions"
      end
  
    end
  end