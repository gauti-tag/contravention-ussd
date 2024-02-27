require 'typhoeus'
# Module for HTTP requests
module HttpService
  
  def http_get(endpoint, headers = {})
    request = Typhoeus::Request.new(endpoint, method: :get, headers: headers)
    request.run
    response = request.response
    JSON.parse(response.body)
  end

  def http_post(endpoint, body, headers = {})
    request = Typhoeus::Request.new(endpoint, method: :post, body: body.to_json, headers: headers)
    request.run
    response = request.response
    JSON.parse(response.body)
  end

end