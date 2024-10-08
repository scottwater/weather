class IpClient < ApplicationClient
  # SSL requires a paid plan for this API
  base_uri "ip-api.com"

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
    IpResponse.new(get("/json"))
  end

  def self.lookup(ip_address)
    response = get("/json/#{ip_address}")
    if response["status"] == "success"
      IpResponse.new(response)
    end
  end
end
