# encoding: utf-8

class ClassificationGroup < ActiveRecord::Base
  # Access restrictions
  attr_accessible :title, :position, :color, :print_color

  has_many :classifications
  attr_accessible :classification_ids

  default_scope order('position DESC')

  def to_s
    self.title
  end
end
