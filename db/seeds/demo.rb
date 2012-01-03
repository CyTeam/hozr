# Demo Seed
# =========
# Tenant
tenant = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Labori", :given_name => "Andre", :street_address => "Hauptstr. 99", :postal_code => "6300", :locality => "Zug", :vcard_type => "praxis")
)

# Employees
zyto = Employee.create!(
  :work_vcard => Vcard.new(:family_name => "Zyti", :given_name => "Christa", :street_address => "Arbeitsweg 8", :postal_code => "6300", :locality => "Zug", :vcard_type => "work")
)
user = User.create!(
  :login => 'zyto',
  :email => 'zyto@example.com',
  :password => 'zyto1234',
  :password_confirmation => 'zyto1234',
  :object => zyto,
  :role_texts => ['zyto']
)

sysadmin = Employee.create!(
  :work_vcard => Vcard.new(:family_name => "Alleskönner", :given_name => "Petra", :street_address => "Tankstellenallee 55", :postal_code => "6300", :locality => "Zug", :vcard_type => "work")
)
user = User.create!(
  :login => 'admin',
  :email => 'admin@example.com',
  :password => 'admin1234',
  :password_confirmation => 'admin1234',
  :object => sysadmin,
  :role_texts => ['sysadmin', 'zyto']
)


# Doctors
Doctor.create!(
  :praxis => Vcard.new(:family_name => "Zuweiser", :given_name => "Peter", :street_address => "Spitalweg 1", :postal_code => "8000", :locality => "Zürich", :vcard_type => "praxis")
)

doctor = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Klientes", :given_name => "Melanie", :street_address => "Zentralgasse 99", :postal_code => "6300", :locality => "Zug", :vcard_type => "praxis")
)

# Classifications
pap_group = ClassificationGroup.create!(
  :title => "PAP",
  :position => 1,
  :color => "white",
  :print_color => "none"
)

eg_group = ClassificationGroup.create!(
  :title => "Extra Gyn",
  :position => 2,
  :color => "green",
  :print_color => "green"
)

for examination_method in ExaminationMethod.all
  Classification.create!([
    {:name => "PAP I", :code => "PAP I", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP II", :code => "PAP II", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP III", :code => "PAP III", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP IIID", :code => "PAP IIID", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP IIIG", :code => "PAP IIIG", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP IV", :code => "PAP IV", :classification_group => pap_group, :examination_method => examination_method},
    {:name => "PAP V", :code => "PAP V", :classification_group => pap_group, :examination_method => examination_method},
  ])
end
