class CreatePriceInfo < ActiveRecord::Migration
  def change
    create_table :price_infos do |t|
      t.float :price
      t.date  :outbound
      t.date  :inbound

      t.timestamps null: false
    end
  end
end
