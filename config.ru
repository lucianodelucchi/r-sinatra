require 'rubygems'
require 'bundler/setup'

Bundler.require

Dir.glob("./{config,helpers,controllers,models}/*.rb").each { |file| require file }

map("/chart") { run ChartController }
map("/") { run ApplicationController }
