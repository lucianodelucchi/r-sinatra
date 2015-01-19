require "rest-client"

class KlmScraper

  ENDPOINT = 'http://www.klm.com'
  CATALOG_URL = '/ams/search/process/flightProductCatalog'

  URL_DEFAULT_PARAMS = {
    "applicationId" => 'EBT7',
    "country" => 'LU',
    "language" => 'en'
  }

  CATALOG_POST_QUERY_PARAMS = {
    lowestPriceSearch:
    {
      flightPreference:"LOWEST_PRICE",
      flightProductFilter:"LOWEST_PRICE",
      numberOfAdults:1,
      numberOfChildren:0,
      numberOfInfants:0,
      cabinClass:"ECONOMY",
      itineraryType:"RETURN",
      connections:[
        { origin:"LUX",
          originType:"CITY",
          destination:"BUE",
          destinationType:"CITY",
          departureDate:nil
        },
        { origin:"BUE",
          originType:"CITY",
          destination:"LUX",
          destinationType:"CITY",
          departureDate: nil
        }
      ]
    }
  }

  def initialize(rest_client)
    @rest_client = rest_client
  end

  def self.build()
    new(RestClient)
  end

  def fetch_prices
    uri_lowest_price_fares = URI(get_flight_product_url)

    # we need to get the params from the URL, they are only placeholders e.g. fromDate={fromDate}&toDate={toDate}
    params_from_uri = CGI::parse uri_lowest_price_fares.query

    query_params = URL_DEFAULT_PARAMS.merge({
      "fromDate" => Date.today.strftime("%F"),
      "toDate" => (Date.today >> 12).strftime("%F"),
      "view" => 'MONTH',
      "upToConnectionIndex" => -1
    })

    # replace the placeholders in the params from the response
    url_params = params_from_uri.merge query_params

    @rest_client.get(uri_lowest_price_fares.host + uri_lowest_price_fares.path, {:params => url_params, :accept => :json}) { |response, request, result, &block|
      case response.code
      when 200
        hash = JSON.parse(response)
        hash["flightProducts"]
      when 400
        response
      else
        response.return!(request, result, &block)
      end
    }
  end

  private
  
  def get_flight_product_url
    encoded = URI.encode_www_form(URL_DEFAULT_PARAMS)
    uri = [ENDPOINT + CATALOG_URL, encoded].join("?")
    response = @rest_client.post(uri, CATALOG_POST_QUERY_PARAMS.to_json, :content_type => :json, :accept => :json)
    catalog = JSON.parse(response)
    link = catalog['lowestPriceFares']['links'].find { |link| link['rel'] == "lowestPriceFares"}
    link['href']
  end
end
