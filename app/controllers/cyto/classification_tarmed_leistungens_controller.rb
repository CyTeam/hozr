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

  def show
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id])
  end

  def new
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.new
  end

  def create
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.new(params[:classification_tarmed_leistungen])
    if @classification_tarmed_leistungen.save
      flash[:notice] = 'ClassificationTarmedLeistungen was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id])
  end

  def update
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id])
    if @classification_tarmed_leistungen.update_attributes(params[:classification_tarmed_leistungen])
      flash[:notice] = 'ClassificationTarmedLeistungen was successfully updated.'
      redirect_to :action => 'show', :id => @classification_tarmed_leistungen
    else
      render :action => 'edit'
    end
  end

  def destroy
    ClassificationTarmedLeistungen.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def update_classification
    classification = Classification.find(params[:classification_tarmed_leistungen][:classification_id])
    
    for tarmed_leistung in params[:classification_tarmed_leistungen][:tarmed_leistungen].split(' ')
      ClassificationTarmedLeistungen.new(:classification => classification, :tarmed_leistung => Tarmed::Leistung.find_by_LNR(tarmed_leistung)).save
    end
    
    redirect_to :action => :list
  end

end
