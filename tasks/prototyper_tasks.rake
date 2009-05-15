require File.dirname(__FILE__) + "/../lib/prototyper"

namespace :prototyper do
  desc "Shows how a render template looks like"
  task :model do
    # TODO extends this so that it can take arguments
    puts Prototyper::Base.rendered_template_for("link_partner", "model.rb")
  end

  desc "Shows how a render template looks like"
  task :controller do
    # TODO extends this so that it can take arguments
    puts Prototyper::Base.rendered_template_for("user", "controller.rb")
  end
  
end

