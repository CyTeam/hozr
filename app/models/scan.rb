class Scan < ActiveRecord::Base
  has_many :pages, :order => :position
end
