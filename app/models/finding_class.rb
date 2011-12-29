# encoding: utf-8

class FindingClass < ActiveRecord::Base
  has_and_belongs_to_many :cases
  belongs_to :finding_group

  scope :by_finding_group, lambda {|group_name|
    if group_name.nil?
      where(:finding_group_id => nil)
    else
      includes(:finding_group).where('finding_groups.name = ?', group_name)
    end
  }
  scope :quality, by_finding_group('Zustand')
  scope :control, by_finding_group('Kontrolle')

  include ActionView::Helpers::SanitizeHelper
  def to_s
    "#{code} - #{strip_tags(name)}"
  end
end
