# ACMbot

This is a version of Github's [Hubot](http://hubot.github.com) that we here at the Temple ACM have deployed to help and amuse us.

This version is designed to be deployed using the [hubot-slack](https://github.com/tinyspeck/hubot-slack) adapter, for use with our Slack. 

###Testing ACMbot locally

ACMbot is meant to be deployed to a UNIX or Linux environment and to interface with slack. This is not the most efficient way to do local testing, however. Luckily, there are better ways.

You can test your hubot by running the following from within the hubot directory.

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/acmadmin/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/acmadmin/Development/hubot/src/scripts
    ACMbot>

Then you can interact with hubot by typing `acmbot help`.

    acmbot> acmbot help

    acmbot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that ACMbot knows about.
    ...


### Scripting

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are useless or boring.  Add whatever functionality you
want hubot to have. Read up on what you can do with hubot in the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).

## Redis Persistence

If you are going to use the `redis-brain.coffee` script from `hubot-scripts`, you will need a redis instance of some sort running on the server. If you don't want to take advantage of the persistence of redis, then feel free to remove this script. Warning: this will make acmbot pretty damn stupid, so it's probably much easier to just install redis-server and leave it running.

## hubot-scripts

There will inevitably be functionality that everyone will want. Instead
of adding it to hubot itself, you can submit pull requests to
[hubot-scripts][hubot-scripts].

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

## external-scripts

ACMbot is now able to load scripts from third-party `npm` packages! To enable
this functionality you can follow the following steps.

1. Add the packages as dependencies into your `package.json`
2. `npm install` to make sure those packages are installed

To enable third-party scripts that you've added you will need to add the package
name as a double quoted string to the `external-scripts.json` file in this repo.

### Deployment

This section is not a complete howto on deploying acmbot to our environment, it's just a quick refresher to get you up and running.

    $ git clone https://github.com/temple-acm/acmbot.git
    $ cd site
    $ sudo npm install -g coffee-script hubot
    $ gpg env.sh.gpg
    $ source env.sh
    $ ./bin/hubot
    $ ./bin/hubot --adapter slack

