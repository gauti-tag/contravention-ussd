module Mmgg
  class FetchRecords < CoreService

    def process
      http_get(endpoint, request_headers)
    end
  
    def endpoint
      "#{ENV['CORE_ENDPOINT']}/api/admin/contravention/list/#{params[:model_code]}"
    end

  end
end