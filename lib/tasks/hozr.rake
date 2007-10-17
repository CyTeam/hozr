namespace :hozr do
  namespace :schema do
    desc "Create a schema dump. Use DATABASE to give the name of the database config. Find the result in 'db/DATABASE-schema.rb'"
    task :dump => :environment do
      ActiveRecord::Base.establish_connection(ENV['DATABASE']) if ENV['DATABASE']

      require 'active_record/schema_dumper'
      File.open(ENV['SCHEMA'] || "db/#{ENV['DATABASE'] || ENV['RAILS_ENV']}-schema.rb", "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    desc "Load a schema dump. Use DATABASE to give the name of the database config. Uses 'db/DATABASE-schema.rb'"
    task :load => :environment do
      ActiveRecord::Base.establish_connection(ENV['DATABASE']) if ENV['DATABASE']

      file = ENV['SCHEMA'] || "db/#{ENV['DATABASE'] || ENV['RAILS_ENV']}-schema.rb"
      load(file)
    end
  end
end
