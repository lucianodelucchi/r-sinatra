namespace :klm do
  desc 'Will query the REST service and save the prices to the DB'
  task :fetch_prices do
    prices = KlmScraper.build().fetch_prices

    to_price_info = ->(fare) {
      {
        :price => fare["price"]["displayPrice"],
        :outbound => fare['connections'][0]['departureDate'],
        :inbound => fare['connections'][1]['departureDate']
      }
    }

    objects_to_persist = prices.map(&to_price_info)
    persisted_objects = PriceInfo.create(objects_to_persist)
    p "Total of new #{persisted_objects.count} prices saved"
  end
end
