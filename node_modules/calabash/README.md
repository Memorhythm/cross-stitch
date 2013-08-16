
Calabash offsers a shortcut for bash command-lines
------

Bash is both a great and a mad tool.

Calabash calls Bash commands from CoffeeScript.
And make it easier to be used in small tasks.

### Usage

You may install this from NPM:  

```
sudo npm install -g calabash
```

And use it togather with `node-dev` to run commands at background:  

```coffee
require("calabash").do "first parameter as comment",
  "pkill -f doodle"
  "coffee -o lib/ -wbc coffee/"
  "jade -o build/ -wP layout/"
  "style -o build/ -w layout/"
  "node-dev server.coffee"
  "doodle build/"
```

With `v0.1.0` new syntax is availale to add tasks in `dev.coffee`:

```coffee
bash = require 'calabash'
bash.add 'task lily',
  'echo lily'
bash.add 'task ted',
  'echo ted'
bash.go()
```

and trigger a special task with `coffee dev.coffee lily`.

It would be better to use it with `node-dev` to enable reloading.

### License

MIT