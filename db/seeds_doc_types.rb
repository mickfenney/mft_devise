if DocumentType.count == 0

  dt = DocumentType.create(
    :name => 'text',
    :display_name => 'Text',
    :description => 'Default Text Documents',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.display_name

  dt = DocumentType.create(
    :name => 'perl',
    :display_name => 'Perl',
    :description => 'Practical Extraction and Report Language',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.display_name

end