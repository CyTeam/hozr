class ActionController::Base
  def self.auto_complete_for_vcard_field(object, method, options = {})
    case method.to_s
    when 'street_address', 'locality'
      model = Address
    else
      model = Vcard
    end
    
    define_method("auto_complete_for_#{object}_#{method}") do
      @items = model.select("DISTINCT #{method}").where("LOWER(#{method}) LIKE ?", params[object][method].downcase + '%').order("#{method} ASC").limit(10).all

      render :inline => "<%= auto_complete_result @items, '#{method}' %>"
    end
  end
  
  def self.auto_complete_for_zip_locality(object)
    define_method("auto_complete_for_#{object}_zip_locality") do
      @localities = PostalCode.where("zip = ?", params[object][:zip_locality]).order('zip').limit(30).all
      render :partial => 'postal_codes/zip_localities'
    end
  end
  
  def self.auto_complete_for_vcard(object)
      auto_complete_for_vcard_field object, :family_name, :limit => 12
      auto_complete_for_vcard_field object, :given_name, :limit => 12
      auto_complete_for_vcard_field object, :street_address, :limit => 12
      auto_complete_for_vcard_field object, :locality, :limit => 12
      auto_complete_for_zip_locality object
  end
end


class ActionView::Helpers::FormBuilder
  def text_field_with_auto_complete(method, tag_options = {}, completion_options = {})
    @template.text_field_with_auto_complete(@object_name, method, tag_options, completion_options)
  end
end


module Rubaidh
  module TabularForm
    class TabularFormBuilder
      def select(field, choices, options)
        field = field.to_s
        label_text, required = extract_tabular_options(field, options)
        generic_field(field, super, label_text)
      end
      
      def text_field_with_auto_complete(field, tag_options = {}, completion_options = {})
        field = field.to_s
        label_text, required = extract_tabular_options(field, completion_options)
        generic_field(field, super, label_text)
      end
    end
  end
end

class Date
  # Date helpers
  def self.parse_date(value, base_year = 2000)
    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return value
      end
      day, month, year = value.split('.').map {|s| s.to_i}
      month ||= Date.today.month
      year ||= Date.today.year
      year = expand_year(year, base_year)
      
      return sprintf("%4d-%02d-%02d", year, month, day)
    else
      return value
    end
  end
  
  def self.date_only_year?(value)
    value.is_a?(String) and value.strip.match /^\d{2,4}$/
  end
  
  def self.expand_year(value, base = 2000)
    year = value.to_i
    return year < 100 ? year + base : year
  end
end


# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
end
