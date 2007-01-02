class Praxistar::Exports < ActiveRecord::Base
  serialize :error_ids
  serialize :find_params
end
