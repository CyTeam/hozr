class Role < ActiveRecord::Base
  has_and_belongs_to_many :users


  # Helpers
  def to_s
    I18n.translate(name, :scope => 'roles')
  end
end
