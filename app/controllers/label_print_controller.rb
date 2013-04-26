# encoding: utf-8
class LabelPrintController < ApplicationController
  authorize_resource :class => false

  private
  def trigger(filename = 'triger.txt')
    FileUtils.touch(Rails.root.join('public', 'trigger', filename))
  end
end
