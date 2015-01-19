class ApplicationController < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers ApplicationHelper

  set :public_folder, File.expand_path('../../public', __FILE__)
  set :views, File.expand_path('../../views', __FILE__)

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
end
