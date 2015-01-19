class ChartController < ApplicationController
  get '/:date/?' do
    @data = PriceInfo.get_formatted_prices_by_month(params[:date]).to_json
    haml :chart
  end
end
