# encoding: utf-8

class CaseNr
  attr_accessor :year, :nr

  def initialize(*params)
    @delimiter='/'

    case params.size
    when 0
      free
    when 1
      parse(params[0])
    end
  end

  def free
    max_case_nr = Case.maximum(:praxistar_eingangsnr, :conditions => "praxistar_eingangsnr < '90/'")
    if max_case_nr.blank?
      parse("1")
    else
      parse(max_case_nr)
      inc!
    end
  end

  def parse(value)
    left, right = value.to_s.split(/[\/-]/)
    if right.nil?
      @year = Date.today.strftime("%y").to_i
      @nr = left.to_i
    else
      @delimiter = value.match(/[\/-]/)
      @year = left.to_i
      @nr = right.to_i
    end
  end

  def to_s
    return "#{sprintf("%02d", @year)}#{@delimiter}#{sprintf("%05d", @nr)}"
  end

  def inc!
    @nr += 1
    self
  end
end
