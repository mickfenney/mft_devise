class ThemeEnum < ActiveEnum::Base
  order :asc

  value id: 'default', name: 'Default'
  value id: 'amelia', name: 'Amelia'
  value id: 'slate', name: 'Slate'
  value id: 'united', name: 'United'

end