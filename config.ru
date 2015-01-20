require 'rubygems'
require 'bundler/setup'

Bundler.require

Dir.glob("./{config,helpers,models}/*.rb").each { |file| require file }

require './app'

run ApplicationController
