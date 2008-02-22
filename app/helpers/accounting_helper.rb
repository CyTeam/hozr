module AccountingHelper
  def currency_fmt(value)
    sprintf("%.2f", value)
  end

  def cu_to_s(value)
    number_to_currency(value, :unit => '')
  end
end
