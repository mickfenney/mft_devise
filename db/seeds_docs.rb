if Document.count == 0 

  doc = Document.create(
    :title => 'test doc',
    :doc_type => 'text',
    :body => 'This is a test document...',
    :user_id => 1,
  )  
  puts '+ doc: ' << doc.title

  doc = Document.create(
    :title => 'new doc',
    :doc_type => 'perl',
    :body => 'This is a new perl document...',
    :user_id => 1,
  )  
  puts '+ doc: ' << doc.title

end  