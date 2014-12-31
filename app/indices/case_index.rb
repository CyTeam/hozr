ThinkingSphinx::Index.define :case, :with => :active_record do
  indexes :praxistar_eingangsnr
  indexes :remarks

  has :entry_date
  has :assigned_at
end
