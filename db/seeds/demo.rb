# Demo Seed
# =========

# User
user_vcard = Vcard.new(:given_name => 'Peter', :family_name => 'Admin', :street_address => 'Gartenstr. 199c', :postal_code => '8888', :locality => 'Zürich')
user_person = Employee.new(:work_vcard => user_vcard)
user = User.new(:login => 'admin', :email => 'admin@example.com', :password => 'demo1234', :password_confirmation => 'demo1234')
user.object = user_person
user.role_texts = ['sysadmin']
user.save
