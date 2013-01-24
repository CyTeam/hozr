# encoding: utf-8

class ResultReport < LetterDocument
  include CasesHelper
  include ApplicationHelper
  include HasVcardsHelper

  def default_options
    super.merge({
      :left_margin   => 2.cm,
      :right_margin  => 2.cm
    })
  end

  # Adapt for result_report
  def letter_header(sender, receiver, subject, date = Date.today)
    # Address
    float do
      canvas do
        bounding_box [12.cm, bounds.top - 6.cm], :width => 10.cm do
          font_size 5.5 do
            text full_address(sender.vcard, ', ') if sender
          end
          draw_address(receiver.vcard, true) if receiver
        end
      end
    end

    move_down 8.cm

    # Place'n'Date
    text [sender.vcard.try(:locality), I18n.l(date, :format => :long)].compact.join(', ') if sender && date

    # Subject
    move_down 35
    text subject, :style => :bold
  end

  def address_indent
    10.cm
  end

  def small_text(text)
    font_size 6.5 do
      self.text text
    end
  end

  def spacer(count = 3)
    count.times {text " "}
  end

  def to_pdf(cases)
    # We accept both a single case or an array
    @cases = cases.is_a?(Array) ? cases : [cases]

    for @case in @cases

    letter_header @case.screener.try(:tenant).try(:person), @case.doctor, @case.to_s, @case.screened_at

    free_text(@case.finding_text)

    if @case.screener && @case.screened_at
      spacer

      indent address_indent do
        text [@case.screener.vcard.honorific_prefix, @case.screener.vcard.full_name].compact.join(' ')
        text @case.screener.vcard.extended_address if @case.screener.vcard.extended_address.present?
        text "Visum #{@case.screened_at}"
      end
    end

    spacer
    if @case.doctor
      small_text "Einsender:"
      text full_address(@case.doctor.vcard, ', ')
    end

    start_new_page unless @case == @cases.last
    end

    render
  end
end
