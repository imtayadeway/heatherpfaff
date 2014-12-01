class VerifiesRecaptcha
  attr_reader :response, :ip, :api_response

  def initialize(response, ip)
    @response = response
    @ip = ip
    @api_response = api_request
    puts "!!!!!!!!!!!!!!!#{ ENV['RECAPTCHA_SECRET'] }"
    puts "!!!!!!!!!!!!!!!#{ api_response }"
  end

  def success?
    success == "true"
  end

  def success
    JSON.parse(api_response.body)["success"]
  end

  private

  def api_request
    Net::HTTP.post_form(URI.parse(api_url), api_params)
  end

  def api_url
    "https://www.google.com/recaptcha/api/siteverify"
  end

  def api_params
    {
      secret: ENV['RECAPTCHA_SECRET'],
      remoteip: ip,
      response: response
    }
  end
end
