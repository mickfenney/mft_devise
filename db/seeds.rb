# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html

puts '+ ROLES'
puts '+ Loading Roles...'
load "#{Rails.root}/db/seeds_roles.rb"

puts '+ DEFAULT USERS'

location1 = Location.create(:address => '75 Seaview Avenue, Safety Beach VIC 3936, Australia', :name => 'Home')
location2 = Location.create(:address => '213 Robinsons Rd, Ravenhall Victoria 3023', :name => 'Work')
user = User.new(
  :name => ENV['ADMIN_NAME'].dup,
  :email => ENV['ADMIN_EMAIL'].dup,
  :password => ENV['ADMIN_PASSWORD'].dup,
  :password_confirmation => ENV['ADMIN_PASSWORD'].dup,
  :locations => [location1, location2]
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.add_role :admin
user.save!

if Rails.env.development?

puts '+ Loading Test Users...'
load "#{Rails.root}/db/seeds_users.rb"

end

puts '+ DEFAULT DOCUMENT TYPES'
puts '+ Loading Document Types...'
load "#{Rails.root}/db/seeds_doc_types.rb"

if Rails.env.development?  
 
  puts '+ DEFAULT DOCUMENTS'
  puts '+ Loading Test Documents...'
  load "#{Rails.root}/db/seeds_docs.rb"

end