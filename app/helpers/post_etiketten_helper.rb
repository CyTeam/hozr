module PostEtikettenHelper
 def doctors_collection
    Doctor.find(:all, :include => {:praxis => :address}, :order => 'vcards.family_name, vcards.given_name', :conditions => {:active => true}).collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
 end
end
