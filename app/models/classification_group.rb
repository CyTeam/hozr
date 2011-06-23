class ClassificationGroup < ActiveRecord::Base
  has_many :classifications

  # Helpers
  def color
    case title
    when 'Azellulär', 'PAP I', 'PAP II'
      'ffffff'
    when 'PAP II agus/ascus', 'PAP II-III', 'PAP II-III agus/ascus'
      'ffff00'
    when 'PAP III'
      '0066ff'
    when 'PAP IV', 'PAP V'
      'ff0000'
    when 'Mama', 'Sputum', 'HPV', 'Urin', 'Extra-gynäkologisches Material'
      '00cc00'
    end
  end

  def print_color
    case title
    when 'Azellulär', 'PAP I', 'PAP II'
      'ffffff'
    when 'PAP II agus/ascus', 'PAP II-III', 'PAP II-III agus/ascus'
      'ffff88'
    when 'PAP III'
      'bbaaff'
    when 'PAP IV', 'PAP V'
      'ff9191'
    when 'Mama', 'Sputum', 'HPV', 'Urin', 'Extra-gynäkologisches Material'
      '74cc74'
    end
  end
end
