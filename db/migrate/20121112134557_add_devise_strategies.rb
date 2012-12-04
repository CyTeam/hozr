class AddDeviseStrategies < ActiveRecord::Migration
  def up
    #confirmation related fields
    rename_column :users, "activation_code", "confirmation_token"
    rename_column :users, "activated_at", "confirmed_at"
    change_column :users, "confirmation_token", :string
    add_column    :users, "confirmation_sent_at", :datetime

    #reset password related fields
    add_column :users, "reset_password_token", :string

    #rememberme related fields
    add_column :users, "remember_created_at", :datetime
  end
end
