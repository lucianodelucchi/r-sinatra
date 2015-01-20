class ApplicationController < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers ApplicationHelper

  configure :development do
    require 'better_errors'
    require "sinatra/reloader"

    register Sinatra::Reloader

    use BetterErrors::Middleware
    BetterErrors.application_root = File.expand_path('..', __FILE__)
  end

  get '/' do
    redirect to("/chart/#{Date.today}")
  end

  get '/chart/:date/?' do
    @data = PriceInfo.get_formatted_prices_by_month(params[:date]).to_json
    haml :chart
  end
end
