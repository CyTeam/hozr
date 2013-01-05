# encoding: utf-8

class ExaminationMethod < ActiveRecord::Base
  # Classifications
  has_many :classifications

  def to_s
    name
  end
end
