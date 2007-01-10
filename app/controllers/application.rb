class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  def concat(*params)
    params.map { |param|
      case param.class.name
      when 'String'
        quote(param)
      when 'Symbol'
        param.to_s
      end
    }.join(' || ')
  end
end

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  def concat(*params)
    params.map! { |param|
      case param.class.name
      when 'String'
        quote(param)
      when 'Symbol'
        param.to_s
      end
    }

    return "CONCAT( #{params.join(', ')} )"
  end
end


module ActionController
  module Macros
    module AutoComplete
      module ClassMethods
        def auto_complete_for_vcard_field(object, method, options = {})
          case method.to_s
          when 'street_address'
            model = Address
          else
            model = Vcard
          end
          
          define_method("auto_complete_for_#{object}_#{method}") do
            find_options = {
              :select => "DISTINCT #{method}",
              :conditions => [ "LOWER(#{method}) LIKE ?", params[object][method].downcase + '%' ],
              :order => "#{method} ASC",
              :limit => 10 }.merge!(options)

            @items = model.find(:all, find_options)

            render :inline => "<%= auto_complete_result @items, '#{method}' %>"
          end
        end
        
        def auto_complete_for_vcard(object)
            auto_complete_for_vcard_field object, :family_name, :limit => 12
            auto_complete_for_vcard_field object, :given_name, :limit => 12
            auto_complete_for_vcard_field object, :street_address, :limit => 12
        end
      end
    end
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
  def to_s
    strftime("%d.%m.%Y")
  end
end

# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
end