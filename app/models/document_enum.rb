class DocumentEnum < ActiveEnum::Base
  order :asc

  value id: 'text', name: 'Text'
  value id: 'perl', name: 'Perl'
  value id: 'ruby', name: 'Ruby'
  value id: 'rails', name: 'Rails'
  value id: 'java', name: 'Java'
  value id: 'php', name: 'PHP'
  value id: 'javascript', name: 'Javascript'
  value id: 'python', name: 'Python'
  value id: 'linux', name: 'Linux'
  value id: 'windows', name: 'Windows'
  value id: 'mac', name: 'Mac'
  value id: 'misc', name: 'Miscellaneous'
  value id: 'html', name: 'HTML'

end