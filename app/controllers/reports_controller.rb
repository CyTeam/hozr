# encoding: utf-8'
class ReportsController < ApplicationController
  def search
    # Use key and value arrays to build contitions
    case_keys = []
    case_values = []

    # Handle case params
    case_params = params[:case] || {}

    unless case_params[:praxistar_eingangsnr].blank?
      if case_params[:praxistar_eingangsnr].match /bis/
        lower_bound, higher_bound = case_params[:praxistar_eingangsnr].split('bis')
        case_keys.push "praxistar_eingangsnr BETWEEN ? AND ?"
        case_values.push CaseCode.new(lower_bound).to_s.strip
        case_values.push CaseCode.new(higher_bound).to_s.strip
      else
        case_keys.push "praxistar_eingangsnr = ?"
        case_values.push CaseCode.new(case_params[:praxistar_eingangsnr]).to_s.strip
      end
    end

    unless case_params[:entry_date].blank?
      if case_params[:entry_date].match /bis/
        lower_bound, higher_bound = case_params[:entry_date].split('bis')
        case_keys.push "entry_date BETWEEN ? AND ?"
        case_values.push Date.parse(lower_bound.strip)
        case_values.push Date.parse(higher_bound.strip)
      else
        case_keys.push "entry_date = ? "
        case_values.push Date.parse(case_params[:entry_date])
      end
    end

    unless case_params[:screened_at].blank?
      if case_params[:screened_at].match /bis/
        lower_bound, higher_bound = case_params[:screened_at].split('bis')
        case_keys.push "screened_at BETWEEN ? AND ?"
        case_values.push Date.parse(lower_bound.strip)
        case_values.push Date.parse(higher_bound.strip)
      else
        case_keys.push "screened_at = ? "
        case_values.push Date.parse(case_params[:screened_at])
      end
    end

    unless case_params[:examination_date].blank?
      if case_params[:examination_date].match /bis/
        lower_bound, higher_bound = case_params[:examination_date].split('bis')
        case_keys.push "examination_date BETWEEN ? AND ?"
        case_values.push Date.parse(lower_bound.strip)
        case_values.push Date.parse(higher_bound.strip)
      else
        case_keys.push "examination_date = ? "
        case_values.push Date.parse(case_params[:examination_date])
      end
    end

    unless case_params[:screener_id].blank?
      case_keys.push "screener_id = ?"
      case_values.push case_params[:screener_id]
    end

    unless case_params[:doctor_id].blank?
      case_keys.push "doctor_id = ?"
      case_values.push case_params[:doctor_id]
    end


    # Only use cases with classifications
    case_keys.push "classification_id IS NOT NULL"
    # Build conditions array
    case_conditions = !case_keys.empty? ? [  case_keys.join(" AND "), *case_values ] : nil

    # The following doesn't work 'cause of a known bug: :include overrides :select
    # @records = Case.find( :all, :select => "classifications.code AS Pap, count(*) AS Anzahl, count(*)/(SELECT count(*) FROM cases)*100.0 AS Prozent", :include => 'classification', :group => 'classifications.code',  :order => "#{order}")

    @count = Case.count(:conditions => case_conditions)

    @group_counts = Case.count(:conditions => case_conditions, :group => 'classification_group_id', :include => [{'classification' => 'classification_group'}], :order => 'classification_groups.position DESC')
  end
end
