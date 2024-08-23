class Ip
  include HTTParty
  base_uri "http://ip-api.com"

  IpResponse = Data.define(:data) do
    def ip
      data["query"]
    end

    def location
      "#{data["city"]} #{data["regionName"]}, #{data["country"]}"
    end
  end

  def self.me
    # If we do not pass an IP Address to the API
    # it will return the current requesting IP
    # and related location info
    IpResponse.new(self.get("/json"))
  end
end