class Mailer < ActionMailer::Base
  TEMP_DIR = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'mailer')
  
  def receive(email)
    scan = Scan.new
    scan.save
    
    temp_dir = File.join(TEMP_DIR, scan.id.to_s)
    FileUtils::mkdir_p(temp_dir)

    case email.subject
    when 'hozr_scan_200dpi'
      page_model = Cyto::OrderForm
    else
      page_model = Page
    end
    
    if email.has_attachments?
      for attachment in email.attachments
        file = File.new(File.join(temp_dir, attachment.original_filename), 'w')
        file.write(attachment.read)
        file.close
        
        page = page_model.new(:file => file)
        page.scan = scan
        page.save
      end
    end
    
    FileUtils::rm_r(temp_dir)
    
    scan.save
  end
end
