# encoding: UTF-8

class AddIndicesToSendQueues < ActiveRecord::Migration
  def self.up
    add_index :send_queues, :mailing_id
    add_index :send_queues, :channel
    add_index :send_queues, :sent_at
  end

  def self.down
  end
end
