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
referer = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Zuweiser", :given_name => "Peter", :street_address => "Spitalweg 1", :postal_code => "8000", :locality => "Zürich", :vcard_type => "praxis"),
  :private => Vcard.new(:family_name => "Zuweiser", :given_name => "Peter", :street_address => "Heimweg 9", :postal_code => "8000", :locality => "Zürich", :vcard_type => "private")
)

doctor = Doctor.create!(
  :praxis => Vcard.new(:family_name => "Klientes", :given_name => "Melanie", :street_address => "Zentralgasse 99", :postal_code => "6300", :locality => "Zug", :vcard_type => "praxis"),
  :private => Vcard.new(:family_name => "Klientes", :given_name => "Melanie", :street_address => "Heimweg 16", :postal_code => "8000", :locality => "Zürich", :vcard_type => "private"),
  :user => User.new(
  :login => 'doctor',
  :email => 'doctor@example.com',
  :password => 'doctor1234',
  :password_confirmation => 'doctor1234'
  )
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

    {:name => "Mama", :code => "Mama", :classification_group => eg_group, :examination_method => examination_method}
  ])
end


# Findings
quality_group = FindingGroup.find_by_name("Zustand")
control_group = FindingGroup.find_by_name("Kontrolle")

FindingClass.create!([
  {:name => "beurteilbar und repräsentativ", :code => "", :finding_group => quality_group},
  {:name => "beurteilbar, keine Zylinderepithel- und/oder Metaplasiezellen", :code => "", :finding_group => quality_group},
  {:name => "beurteilbar, aber nicht repräsentativ", :code => "", :finding_group => quality_group},
  {:name => "nicht beurteilbar", :code => "000", :finding_group => quality_group}
])

FindingClass.create!([
  {:name => "Kontrolle in 3 Jahren", :code => "3j", :finding_group => control_group},
  {:name => "Kontrolle in 6 Monaten", :code => "6m", :finding_group => control_group}
])
