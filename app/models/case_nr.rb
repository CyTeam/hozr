# encoding: utf-8

class CaseNr
  attr_accessor :year, :nr
  
  def initialize(*params)
    @delimiter='/'
    
    case params.size
    when 0
      max_case_nr = Case.maximum(:praxistar_eingangsnr, :conditions => "praxistar_eingangsnr < '90/'")
      if max_case_nr.nil? or max_case_nr == ''
        parse("1")
      else
        parse(max_case_nr)
        inc!
      end
    when 1
      param = params[0]
      case param.class.name
      when 'String'
        parse(param)
      when 'Fixnum'
        parse(param.to_s)
      when 'Hash'
        @year = param[:year]
        @nr = param[:nr]
      end
    when 2
      @year = params[0].to_i
      @nr = params[1].to_i
    end
  end
  
  def parse(value)
    left, right = value.split(/[\/-]/)
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

  def inc
    clone.inc!
  end

  def inc!
    @nr += 1
    self
  end
  
  def dec!
    @nr -= 1
    self
  end

  def dec
    clone.dec!
  end
  
  def self.free
    new
  end

  def self.next(previous = nil)
    previous ? new(previous).inc! : new
  end
end
