Bundler.require

require "sinatra/activerecord/rake"

Dir.glob("./{config,lib,models}/*.rb").each { |file| require file }
Dir.glob('lib/tasks/*.rake').each { |r| load r}
