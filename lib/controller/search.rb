module Controller
  module Search
    def vcard_conditions
      vcard_params = params[:vcard] || {}
      keys = []
      values = []
      
      fields = vcard_params.reject { |key, value| value.nil? or value.empty? or key == 'zip_locality'}
      if (zip_locality = vcard_params[:zip_locality]).present?
        postal_code, locality = Vcard.parse_zip_locality(zip_locality)
        fields[:postal_code] = postal_code if postal_code.present?
        fields[:locality]    = locality if locality.present?
      end
      fields.each { |key, value|
        keys.push "#{key} LIKE ?"
        values.push '%' + value.downcase.gsub(' ', '%') + '%'
      }
      
      return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
    end

    def patient_conditions
      parameters = params[:patient] || {}
      keys = []
      values = []
      
      unless parameters[:doctor_patient_nr].nil? or parameters[:doctor_patient_nr].empty?
        keys.push "doctor_patient_nr = ?"
        values.push parameters[:doctor_patient_nr].strip
      end
      
      unless parameters[:birth_date].nil? or parameters[:birth_date].empty?
        if parameters[:birth_date].match /bis/
          lower_bound, higher_bound = parameters[:birth_date].split('bis')
          if Date.date_only_year?(lower_bound)
              keys.push "YEAR(birth_date) BETWEEN ? AND ?"
              values.push expand_year(lower_bound.strip)
              values.push expand_year(higher_bound.strip)
          else
              keys.push "birth_date BETWEEN ? AND ?"
              values.push Date.parse_date(lower_bound.strip, 1900)
              values.push parse_date(higher_bound.strip, 1900)
          end
        else
          if Date.date_only_year?(parameters[:birth_date])
              keys.push "YEAR(birth_date) = ?"
              values.push Date.expand_year(parameters[:birth_date].strip)
          else
              keys.push "birth_date = ? "
              values.push Date.parse_date(parameters[:birth_date], 1900)
          end
        end
      end
    
      return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
    end
  end
end
