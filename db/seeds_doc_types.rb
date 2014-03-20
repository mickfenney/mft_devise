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

  dt = DocumentType.create(
    :name => 'Java',
    :description => 'Java (programming language)',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'Ruby',
    :description => 'Ruby (programming language)',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'HTML',
    :description => 'Hypertext Markup Language',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'MySQL',
    :description => 'MySQL is a relational database management system (RDBMS)',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name  

  dt = DocumentType.create(
    :name => 'PL/SQL',
    :description => 'Procedural Language/Structured Query Language (PL/SQL)',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'Javascript',
    :description => 'JavaScript (JS) is an interpreted computer programming language',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

  dt = DocumentType.create(
    :name => 'Rails',
    :description => 'Ruby on Rails, is an open source web application framework',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name  

  dt = DocumentType.create(
    :name => 'PHP',
    :description => 'PHP: Hypertext Preprocessor',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name   

  dt = DocumentType.create(
    :name => 'PostgreSQL',
    :description => 'PostgreSQL, often simply "Postgres", is an open-source object-relational database management system (ORDBMS)',
    :user_id => 1,
  )
  puts '+ doc type: ' << dt.name

end