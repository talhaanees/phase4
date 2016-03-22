module NavigationHelpers
  def path_to(page_name)
    case page_name
 
    when /the home\s?page/
      '/'
    when /the About Us\s?page/
      about_path
    when /the Contact Us\s?page/
      contact_path
    when /the Privacy\s?page/
      privacy_path
      
    when /the employees\s?page/ 
      employees_path
    when /details on Evan Schell/
      employee_path(@schell)
    when /edit Jake's\s?record/
      edit_employee_path(@correa) 
    when /the new employee\s?page/
      new_employee_path
      
    when /the stores\s?page/ 
      stores_path
    when /the Convention Center store\s?page/ 
      store_path(@convention)
    when /the new store\s?page/
      new_store_path
    when /edit the CMU store/
      edit_store_path(@cmu)
      
    when /the assignments index page/ 
      assignments_path
    when /the new assignment page/
      new_assignment_path

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)