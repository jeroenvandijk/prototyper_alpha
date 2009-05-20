module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    # helper_method = page_name.gsub(' ', '_') + "_path"
    # raise helper_method + " " + respond_to?(helper_method.to_sym).inspect + send(helper_method.to_sym)
    case page_name
    
    when /the homepage/
      '/'
    when /the new post page/
      new_post_path
    # when /cucumber users/
    #   cucumber_users_path
    #   
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        helper_method = page_name.gsub(' ', '_') + "_path"
        send(helper_method)
      rescue NoMethodError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end

    end
  end
end

World(NavigationHelpers)
