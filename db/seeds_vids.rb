if Video.count == 0 

  vid = Video.create(
    :name => 'Summernats - Burnouts',
    :code => 'epKqF5hAWf4',
    :description => 'Summernats 25 Top Ten Burnouts 2012',
    :user_id => 1,
  )
  puts '+ vid: ' << vid.name

end