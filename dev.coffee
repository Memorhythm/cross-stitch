
require('calabash').do 'dev',
  'pkill -f doodle'
  'jade -o ./ -wP layout/index.jade'
  'stylus -o build/ -w layout/'
  'watchify -o build/bundle.js -dt coffeeify coffee/main.coffee -v'
  'doodle index.jade log:yes build/'