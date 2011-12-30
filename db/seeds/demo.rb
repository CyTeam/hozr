# Demo Seed
# =========
# Tenant
tenant = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Labori", :given_name => "Andre", :street_address => "Hauptstr. 99", :postal_code => "6300", :locality => "Zug", :vcard_type => "praxis")
)

# User
user = User.create!(
  :login => 'admin',
  :email => 'admin@example.com',
  :password => 'admin1234',
  :password_confirmation => 'admin1234',
  :object => tenant,
  :role_texts => ['sysadmin', 'zyto']
)

# Doctors
Doctor.create!(
  :praxis => Vcard.new(:family_name => "Zuweiser", :given_name => "Peter", :street_address => "Spitalweg 1", :postal_code => "8000", :locality => "Zürich", :vcard_type => "praxis")
)

doctor = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Klientes", :given_name => "Melanie", :street_address => "Zentralgasse 99", :postal_code => "6300", :locality => "Zug", :vcard_type => "praxis")
)
