# encoding: UTF-8

class AddOutputToSendQueues < ActiveRecord::Migration
  def self.up
    add_column :send_queues, :output, :text
  end

  def self.down
    remove_column :send_queues, :output
  end
end
