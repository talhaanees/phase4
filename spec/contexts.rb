# require needed files

require './spec/sets/store_contexts'
require './spec/sets/employee_contexts'
require './spec/sets/assignment_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::StoreContexts
  include Contexts::EmployeeContexts
  include Contexts::AssignmentContexts

end