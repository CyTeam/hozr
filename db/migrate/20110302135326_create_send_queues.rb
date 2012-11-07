# encoding: UTF-8

class CreateSendQueues < ActiveRecord::Migration
  def self.up
    create_table :send_queues do |t|
      t.integer :mailing_id
      t.string :channel

      t.timestamps
    end
  end

  def self.down
    drop_table :send_queues
  end
end
