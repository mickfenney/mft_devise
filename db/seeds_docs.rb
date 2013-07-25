if Document.count == 0 

  doc = Document.create(
    :title => 'text doc',
    :document_type_id => 1,
    :body => 'This is a test document...',
    :user_id => 1,
  )  
  puts '+ doc: ' << doc.title

  doc = Document.create(
    :title => 'perl doc',
    :document_type_id => 2,
    :body => 'This is a new perl document...',
    :user_id => 1,
  )  
  puts '+ doc: ' << doc.title

end  