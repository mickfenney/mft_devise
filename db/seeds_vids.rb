if Video.count == 0 

  vid = Video.create(
    :name => 'Summernats - Burnouts',
    :code => 'epKqF5hAWf4',
    :description => 'This is a test youtube video of the sumernats burnout competition...',
    :user_id => 1,
  )
  puts '+ vid: ' << vid.name

end