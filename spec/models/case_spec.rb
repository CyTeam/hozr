require "spec_helper"

describe Case do
  context "#new" do
    it "should work with no parameter" do
      Case.new
    end

    it "should work with a hash" do
      Case.create(:praxistar_eingangsnr => '112233', :intra_day_id => 1, :entry_date => Date.today)
    end
  end
end
