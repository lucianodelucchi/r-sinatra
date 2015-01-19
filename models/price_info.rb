class PriceInfo < ActiveRecord::Base
  validates_numericality_of :price
  scope :created_after, ->(date = Date.today) { where("created_at >= ?", date) }

  def graph_index
    outbound.strftime("%b %Y")
  end

  def format_for_graph
    { :x => created_at.to_datetime.strftime('%Q').to_i, :y => price }
  end

  class << self
    def get_formatted_prices_by_month(date = Date.today)
      prices = self.created_after(date).group_by(&:graph_index)
      prices.inject([]) do
        |ary, (group, objects)|
        formatted_values = objects.map(&:format_for_graph)
        ary << { :key => group, :values => formatted_values }
        ary
      end
    end
  end
end
