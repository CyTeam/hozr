class ScheduleController < ApplicationController

  def list_new
    @cases = Cyto::Case.find :all, :conditions => 'centrifuged_at IS NULL', :order => 'id'
  end

  def list_centrifuged
    @cases = Cyto::Case.find :all, :conditions => 'centrifuged_at IS NOT NULL AND scheduled_at IS NULL', :order => 'id'
  end

  def list_scheduled
    @cases = Cyto::Case.find :all, :conditions => 'scheduled_at IS NOT NULL', :order => 'id'
  end
end
