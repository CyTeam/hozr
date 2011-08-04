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
  end
end
