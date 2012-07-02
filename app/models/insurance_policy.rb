class InsurancePolicy < ActiveRecord::Base
  # Scopes
  scope :by_policy_type, lambda {|policy_type|
    where(:policy_type => policy_type)
  }

  # Associations
  belongs_to :insurance
  belongs_to :patient

  # Validations
#  validates_presence_of :insurance

  def to_s(format = :default)
    ident = insurance.to_s
    ident += " ##{number}" unless number.blank?

    case format
    when :long
      return "#{policy_type}: #{ident}"
    else
      return ident
    end
  end
end
