# encoding: utf-8

class ClassificationGroup < ActiveRecord::Base
  has_many :classifications
end
