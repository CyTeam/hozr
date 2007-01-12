class AdminController < ApplicationController

  def index
  end

  def praxistar_create_all_leistungsblatt
    Cyto::Case.praxistar_create_all_leistungsblatt
  end

  def praxistar_patienten_personalien_export
    Praxistar::PatientenPersonalien.export
  end
end
