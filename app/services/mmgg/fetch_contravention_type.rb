module Mmgg 
    class FetchContraventionType < CoreService
        def process
            http_post(endpoint, { request: params }, request_headers)
        end

        def endpoint 
            "#{ENV['CORE_ENDPOINT']}/api/contravention/type"
        end
    end
end