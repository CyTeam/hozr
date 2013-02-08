# encoding: utf-8

# Barcode
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class ResultReport < LetterDocument
  include CasesHelper
  include ApplicationHelper
  include HasVcardsHelper

  # Adapt for result_report

  def default_options
    super.merge({
      :left_margin   => 2.cm,
      :right_margin  => 2.cm
    })
  end

  def letter_header(sender, receiver, subject, date = Date.today)
    # Address
    float do
      canvas do
        bounding_box [12.cm, bounds.top - 5.cm], :width => 10.cm do
          font_size 5.5 do
            text full_address(sender.vcard, ', ') if sender
          end
          text " "
          draw_address(receiver.vcard, true) if receiver
        end
      end
    end

    move_down 7.cm

    # Place'n'Date
    text [sender.vcard.try(:locality), I18n.l(date, :format => '%d. %B %Y')].compact.join(', ') if sender && date

    # Subject
    text " "
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

  def spacer(count = 2)
    count.times {text " "}
  end

  def form_label(a_case)
    barcode = Barby::Code128C.new(a_case.code)
    barcode.annotate_pdf(self, :unbleed => 0.1, :height => 0.6.cm, :xdim => 1)

    move_down 0.1.cm
    small_text a_case.code_to_s
  end

  def to_pdf(cases)
    # We accept both a single case or an array
    @cases = cases.is_a?(Array) ? cases : [cases]

    for @case in @cases

    float do
      bounding_box [10.cm, bounds.top - 2.5.cm], :width => 10.cm do
        form_label(@case)
      end
    end

    letter_header @case.review_by.try(:tenant).try(:person), @case.doctor, @case.to_s, @case.review_at

    free_text(@case.finding_text)

    if @case.review_by && @case.review_at
      spacer

      indent address_indent do
        text [@case.review_by.vcard.honorific_prefix, @case.review_by.vcard.full_name].compact.join(' ')
        text @case.review_by.vcard.extended_address if @case.review_by.vcard.extended_address.present?
        text "Visum #{@case.review_at}"
      end
    end

    spacer
    if @case.doctor
      small_text "Einsender:"
      text full_address(@case.doctor.vcard, ', ')
    end
    if @case.case_copy_tos.present?
      small_text "Kopie an:"
      @case.case_copy_tos.each do |case_copy_to|
        text full_address(case_copy_to.person.vcard, ', ')
      end
    end

    if @case.classification
      small_text @case.classification.code
    end

    if @case.order_form
      start_new_page

      @case.order_form.send(:file_state).create_magick_version_if_needed(:mail)
      image @case.order_form.file('mail'), :width => bounds.width
    end

    start_new_page unless @case == @cases.last
    end

    render
  end
end
