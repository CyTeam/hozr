class User < ActiveRecord::Base
  belongs_to :object, :polymorphic => true

  validates_uniqueness_of   :login
  
  # Helpers
  def to_s
    object.name
  end
end
