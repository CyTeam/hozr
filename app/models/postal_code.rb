# encoding: utf-8

class PostalCode < ActiveRecord::Base
  include PostalCodes::Import
end
