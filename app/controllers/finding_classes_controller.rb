# encoding: utf-8'

class FindingClassesController < AuthorizedController
  def create
    create! { new_finding_class_path }
  end
end
