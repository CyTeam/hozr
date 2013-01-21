# encoding: utf-8

class FindingClass < ActiveRecord::Base
  has_and_belongs_to_many :cases
  belongs_to :finding_group
  has_and_belongs_to_many :classifications, :join_table => :top_finding_classes

  scope :by_finding_group, lambda {|group_name|
    if group_name.nil?
      where(:finding_group_id => nil)
    else
      includes(:finding_group).where('finding_groups.name = ?', group_name)
    end
  }
  scope :quality, by_finding_group('Zustand')
  scope :control, by_finding_group('Kontrolle')

  # Attributes
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  def name=(value)
    self[:name] = sanitize(value)
  end

  def to_s
    [code, truncate(strip_tags(name), :length => 40)].map(&:presence).compact.join(" - ")
  end
end
