class ReportsController < ApplicationController

  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)

  def pap_groups
    @records = ActiveRecord::Base.find_by_sql('SELECT substr(praxistar_eingangsnr, 1, 2) AS year, classifications.name AS pap, count(*) AS count FROM cases JOIN classifications ON cases.classification_id = classifications.id GROUP BY substr(praxistar_eingangsnr, 1, 2), classifications.code')
#    Case.find_by_sql('SELECT left(praxistar_eingangsnr, 2) AS year, classifications.name AS pap, count(*) AS count FROM cases JOIN classifications ON cases.classification_id = classifications.id GROUP BY left(praxistar_eingangsnr, 2), classifications.code')
    
    render :action => :statistics
  end
  
  def cyto_cases
    g = Gruff::Line.new
    # Uncomment to use your own theme or font
    # See http://colourlovers.com or http://www.firewheeldesign.com/widgets/ for color ideas
#     g.theme = {
#       :colors => ['#663366', '#cccc99', '#cc6633', '#cc9966', '#99cc99'],
#       :marker_color => 'white',
#       :background_colors => ['black', '#333333']
#     }
#     g.font = File.expand_path('artwork/fonts/VeraBd.ttf', RAILS_ROOT)

    g.title = "Anzahl PAP"
    
    g.data("Total", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/'").size])

    g.data("PAP I", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/' and classification_id = 1").size])

    g.data("PAP II", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/' and classification_id = 2").size])

    g.labels = {0 => '2002', 1 => '2003', 2 => '2004', 3 => '2005', 4 => '2006', 5 => '2007' }

    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "cyto_cases.png")
  end

end
