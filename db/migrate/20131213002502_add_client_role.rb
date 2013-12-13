class AddClientRole < ActiveRecord::Migration
  def up
    Role.create! :name => 'client'
  end

  def down
    Role.where(:name => 'client').destroy_all
  end
end
