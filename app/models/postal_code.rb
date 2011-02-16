class PostalCode < ActiveRecord::Base
  include PostalCodes::Import
end
