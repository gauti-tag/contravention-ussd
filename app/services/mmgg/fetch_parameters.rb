module Mmgg
    class FetchParameters < CoreService
  
      def process
        http_get(endpoint, request_headers)
      end
    
      def endpoint
        "#{ENV['CORE_ENDPOINT']}/api/admin/contravention/parameters"
      end
  
    end
  end