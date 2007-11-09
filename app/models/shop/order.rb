class Shop::Order < ActiveRecord::Base
  use_db :prefix => "shop_"
end
