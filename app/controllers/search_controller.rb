# encoding: utf-8'
class SearchController < ApplicationController
  def index
    query = params[:query]

    @patients = Patient.by_text(query, :star => true, :per_page => 30, :page => params[:page])
  end
end
