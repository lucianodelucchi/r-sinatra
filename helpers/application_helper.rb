module ApplicationHelper
  include Rack::Utils
  alias_method :h, :escape_html
end
