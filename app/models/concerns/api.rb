module Api
  extend ActiveSupport::Concern
  included do
    def self.call_api(url, param={})
      jsonData = nil
      begin
        httpClient = HTTPClient.new
        data = httpClient.get_content(url, param)
        jsonData = JSON.parse data
        rescue HTTPClient::BadResponseError => e
        rescue HTTPClient::TimeoutError => e
      end
      return jsonData
    end
  end
end
