# encoding: UTF-8

class AddSentAtToSendQueues < ActiveRecord::Migration
  def self.up
    add_column :send_queues, :sent_at, :datetime
  end

  def self.down
    remove_column :send_queues, :sent_at
  end
end
