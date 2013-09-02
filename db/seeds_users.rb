user = User.new(
  :name => 'user',
  :email => 'user@example.com',
  :password => 'password',
  :password_confirmation => 'password',
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.add_role :admin
user.save!

user = User.new(
  :name => 'test',
  :email => 'test@example.com',
  :password => 'password',
  :password_confirmation => 'password',
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.save!

user = User.new(
  :name => 'docs',
  :email => 'docs@example.com',
  :password => 'password',
  :password_confirmation => 'password',
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.add_role :docs
user.save!

user = User.new(
  :name => 'pics',
  :email => 'pics@example.com',
  :password => 'password',
  :password_confirmation => 'password',
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.add_role :pics
user.save!

user = User.new(
  :name => 'vids',
  :email => 'vids@example.com',
  :password => 'password',
  :password_confirmation => 'password',
)
puts '+ user: ' << user.name
user.skip_confirmation!
user.add_role :vids
user.save!

50.times do

  user = User.new(
    :name => Faker::Name.name,
    :email => Faker::Internet.email,
    :password => 'password',
    :password_confirmation => 'password',
  )
  puts '+ user: ' << Faker::Name.name
  user.skip_confirmation!
  user.save!

end