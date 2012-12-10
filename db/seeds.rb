# encoding: UTF-8

# General Seeds
# =============
HonorificPrefix.create!([
  {:sex => 1, :position => 1, :name => 'Herr'},
  {:sex => 1, :position => 2, :name => 'Herr Dr.'},
  {:sex => 1, :position => 3, :name => 'Herr Dr. med.'},
  {:sex => 1, :position => 4, :name => 'Herr Prof.'},
  {:sex => 2, :position => 1, :name => 'Frau'},
  {:sex => 2, :position => 2, :name => 'Frau Dr.'},
  {:sex => 2, :position => 3, :name => 'Frau Dr. med.'},
  {:sex => 2, :position => 4, :name => 'Frau Prof.'}
])

# Authorization
# =============
Role.create!([
  {:name => 'sysadmin'},
  {:name => 'zyto'},
  {:name => 'admin'},
  {:name => 'doctor'}
])

# Examination Methods
# ===================
ExaminationMethod.create!([
  {:name => 'Dünnschicht'},
  {:name => 'Konventionel'}
])

# Finding Groups
# ==============
FindingGroup.create!([
  {:name => "Zustand"},
  {:name => "Kontrolle"}
])
