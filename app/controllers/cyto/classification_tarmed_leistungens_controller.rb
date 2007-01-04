class Cyto::ClassificationTarmedLeistungensController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @classification_tarmed_leistungen_pages, @classification_tarmed_leistungens = paginate :classification_tarmed_leistungens, :per_page => 10
  end

  def update_classification
    classification = Classification.find(params[:classification_tarmed_leistungen][:classification_id])
    
    for tarmed_leistung in params[:classification_tarmed_leistungen][:tarmed_leistungen].split(' ')
      ClassificationTarmedLeistungen.new(:classification => classification, :tarmed_leistung => Tarmed::Leistung.find_by_LNR(tarmed_leistung)).save
    end
    
    redirect_to :action => :list
  end
end
