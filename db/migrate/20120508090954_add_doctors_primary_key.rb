class AddDoctorsPrimaryKey < ActiveRecord::Migration
  def up
    Doctor.connection.execute("ALTER TABLE doctors ADD PRIMARY KEY (id)")
  end

  def down
  end
end
