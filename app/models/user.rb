class User < ActiveRecord::Base
  # CyDoc
  belongs_to :object, :polymorphic => true
end
