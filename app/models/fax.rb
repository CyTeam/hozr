class Fax < ActiveRecord::Base
  attr_accessible :receiver_id, :receiver_type

  # Number
  attr_accessible :number
  validates :number, :presence => true, :format => /[0-9 \/]/
  def number=(value)
    self[:number] = value.delete(' /').strip
  end

  # Sender
  belongs_to :sender, :class_name => 'Person', :foreign_key => :sender_id
  attr_accessible :sender_id, :sender

  # Case
  belongs_to :case
  attr_accessible :case_id

  # Actions
  def send_fax
    filename = Rails.root.join('system', 'fax_queue', "#{number}_#{id}.pdf")
    File.open(filename, 'w') do |file|
      file.binmode
      file.write self.case.to_pdf
    end
  end
end
