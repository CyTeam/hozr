class ReportsController < ApplicationController

  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)

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
    
    g.data("2005", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/'").size])

    g.labels = {0 => '2004', 1 => '2005', 2 => '2006', 3 => '2007'}

    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "cyto_cases.png")
  end

end
