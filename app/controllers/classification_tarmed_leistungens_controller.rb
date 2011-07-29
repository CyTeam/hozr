class ClassificationTarmedLeistungensController < ApplicationController
  auto_complete_for :classification_tarmed_leistungen, :tarmed_leistung_id, :limit => 100
  auto_complete_for :classification_tarmed_leistungen, :parent_id, :limit => 100

  def index
    list
    render :action => 'list'
  end

  def list
  end

  def show
    @classification = Classification.find(params[:id])
  end

  def new
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.new(:classification_id => params[:classification_id])
  end

  def create
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.new(params[:classification_tarmed_leistungen])
    if @classification_tarmed_leistungen.save
      flash[:notice] = 'ClassificationTarmedLeistungen was successfully created.'
      redirect_to :action => 'show', :id => @classification_tarmed_leistungen.classification
    else
      render :action => 'new'
    end
  end

  def edit
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id])
  end

  def update
    @classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id])
    if @classification_tarmed_leistungen.update_attributes(params[:classification_tarmed_leistungen]) and @classification_tarmed_leistungen.tarmed_leistung
      flash[:notice] = 'ClassificationTarmedLeistungen was successfully updated.'
      redirect_to :action => 'show', :id => @classification_tarmed_leistungen.classification
    else
      render :action => 'edit'
    end
  end

  def destroy
    classification_tarmed_leistungen = ClassificationTarmedLeistungen.find(params[:id]).destroy
    redirect_to :action => 'show', :id => classification_tarmed_leistungen.classification
  end

  def update_classification
    classification = Classification.find(params[:classification_tarmed_leistungen][:classification_id])
    
    for tarmed_leistung in params[:classification_tarmed_leistungen][:tarmed_leistungen].split(' ')
      ClassificationTarmedLeistungen.new(:classification => classification, :tarmed_leistung => Tarmed::Leistung.find_by_LNR(tarmed_leistung)).save
    end
    
    redirect_to :action => :list
  end

end
