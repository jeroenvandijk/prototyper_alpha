require File.dirname(__FILE__) + "/../lib/prototyper"

namespace :prototyper do
  desc "Shows the dynamically created class or template"
  task :export, [:resource, :path] do |t, args|
    puts Prototyper::Base.rendered_template_for(args.resource, args.path)
  end
  
  desc "Runs migrations for the prototypes"
  task :migrate => :environment do
    Prototyper::Migrator.reinstall
    
    puts "Ran migrations for environment #{RAILS_ENV}"
  end
  
  desc "Runs all seeds"
  task :seed => :environment do
    File.open("app/prototypes/seed.rb", 'r') {|f| eval f.read }
    
    puts "Seeded the #{RAILS_ENV} database"
  end
  
  
  
  
end

