
require('../coffee/').do "demo first",
  "echo a"
  "echo b"

require('../coffee').add 'task lily',
  'echo lily'

require('../coffee').add 'task ted',
  'echo ted'

require('../coffee').go()