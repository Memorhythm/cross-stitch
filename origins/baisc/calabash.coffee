
require('calabash').do 'dev',
  'pkill -f doodle'
  'coffee -o src/ -cmw coffee/'
  'doodle index.html src/ log:yes'