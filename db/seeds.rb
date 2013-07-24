# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
#user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#puts 'user: ' << user.name
#user.confirm!
#user.save!

location1 = Location.create(:address => '75 Seaview Avenue, Safety Beach VIC 3936, Australia', :name => 'Home')
location2 = Location.create(:address => '213 Robinsons Rd, Ravenhall Victoria 3023', :name => 'Work')
user = User.new(
  :name => ENV['ADMIN_NAME'].dup,
  :email => ENV['ADMIN_EMAIL'].dup,
  :password => ENV['ADMIN_PASSWORD'].dup,
  :password_confirmation => ENV['ADMIN_PASSWORD'].dup,
  :locations => [location1, location2]
)
puts 'user: ' << user.name
user.skip_confirmation!
user.add_role :admin
user.save!

if Rails.env.development?

  user = User.new(
    :name => 'user',
    :email => 'user@example.com',
    :password => 'password',
    :password_confirmation => 'password',
  )
  puts 'user: ' << user.name
  user.skip_confirmation!
  user.add_role :admin
  user.save!

  user = User.new(
    :name => 'test',
    :email => 'test@example.com',
    :password => 'password',
    :password_confirmation => 'password',
  )
  puts 'user: ' << user.name
  user.skip_confirmation!
  user.save!

  user = User.new(
    :name => 'docs',
    :email => 'docs@example.com',
    :password => 'password',
    :password_confirmation => 'password',
  )
  puts 'user: ' << user.name
  user.skip_confirmation!
  user.add_role :docs
  user.save!

  50.times do

    user = User.new(
      :name => Faker::Name.name,
      :email => Faker::Internet.email,
      :password => 'password',
      :password_confirmation => 'password',
    )
    puts 'user: ' << Faker::Name.name
    user.skip_confirmation!
    user.save!

  end

  puts 'DEFAULT DOCUMENT TYPES'
  dt = DocumentType.new(
    :name => 'text',
    :display_name => 'Text',
    :description => 'Default text documents',
    :user_id => 1,
  )
  dt.save!
  puts 'doc type: ' << dt.display_name

  dt = DocumentType.new(
    :name => 'perl',
    :display_name => 'Perl',
    :description => 'Practical Extraction and Report Language',
    :user_id => 1,
  )
  dt.save!
  puts 'doc type: ' << dt.display_name 
 
  puts 'DEFAULT DOCUMENTS'
  doc = Document.new(
    :title => 'test doc',
    :doc_type => 'text',
    :body => 'This is a test document...',
    :user_id => 1,
  )  
  doc.save!
  puts 'doc: ' << doc.title

  doc = Document.new(
    :title => 'new doc',
    :doc_type => 'text',
    :body => 'This is a new test document...',
    :user_id => 1,
  )  
  doc.save!
  puts 'doc: ' << doc.title

end