class Mailer < ActionMailer::Base
  TEMP_DIR = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'mailer')
  
  def receive(email)
    scan = Scan.new
    scan.save
    
    temp_dir = File.join(TEMP_DIR, scan.id.to_s)
    FileUtils::mkdir_p(temp_dir)

    if email.has_attachments?
      for attachment in email.attachments
        file = File.new(File.join(temp_dir, attachment.original_filename), 'w')
        file.write(attachment.read)
        file.close
        
        scan.pages.create(:file => file)
      end
    end
    
    FileUtils::rm_r(temp_dir)
    
    scan.save
  end
end