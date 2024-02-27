require 'typhoeus'
# Authentication
module CoreApiToken

  def auth_token
    token = REDIS_CLIENT.get('core:auth_token')
    return token if token.present?

    request = Typhoeus::Request.new(auth_endpoint, method: :post, body: auth_params.to_json, headers: { 'Content-Type': 'application/json' })
    request.run
    response = request.response
    if response.code == 200
      token = JSON.parse(response.body)['token']
      REDIS_CLIENT.setex('core:auth_token', 1.hour.to_i, token)
    end
    token
  end

  def auth_endpoint
    "#{ENV['CORE_ENDPOINT']}/platform/auth"
  end

  def auth_params
    {
      auth: {
        api_key: ENV['CORE_API_KEY'],
        api_secret: ENV['CORE_API_SECRET']
      }
    }
  end
end