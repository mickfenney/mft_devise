if DocumentType.count == 0

  dt = DocumentType.create(
    :name => 'Text',
    :description => 'Default Text Documents',
    :user_id => 1,    
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'Perl',
    :description => 'Practical Extraction and Report Language',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

end