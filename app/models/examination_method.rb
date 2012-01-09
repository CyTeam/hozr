# encoding: utf-8

class ExaminationMethod < ActiveRecord::Base
  # Classifications
  has_many :classifications
end
