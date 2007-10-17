namespace :hozr do
  namespace :schema do
    desc "Create a db/schema.rb file that can be portably used against any DB supported by AR"
    task :dump => :environment do
      ActiveRecord::Base.establish_connection(ENV['DATABASE']) if ENV['DATABASE']

      require 'active_record/schema_dumper'
      File.open(ENV['SCHEMA'] || "db/#{ENV['DATABASE'] || ENV['RAILS_ENV']}-schema.rb", "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    desc "Load a schema.rb file into the database"
    task :load => :environment do
      ActiveRecord::Base.establish_connection(ENV['DATABASE']) if ENV['DATABASE']

      file = ENV['SCHEMA'] || "db/#{ENV['DATABASE'] || ENV['RAILS_ENV']}schema.rb"
      load(file)
    end
  end
end
