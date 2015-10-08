Teamtrope
========

- [Requirements](#requirements)
- [Installation](#installation)

---

Requirements
------------

### Ruby and Rails

*Ruby 2.1.3

*Rails 4.1.6

Compare the above versions of ruby and rails with the [GemFile](https://github.com/Booktrope/teamtrope-rails/blob/master/Gemfile)

### Redis

[redis.io](http://redis.io) is used to queue tasks to run on a worker process to keep long tasks off of the web threads.

### Image Processor

[ImageMagick](http://www.imagemagick.org)
requirement for [Paperclip](https://github.com/thoughtbot/paperclip) gem which we use for attachments and avatars

### Entity Relationship Diagram
[Graphviz](http://graphviz.org)

### Database

[Postgres](http://www.postgresql.org)

Installation
------------

Using homebrew and rbenv

Install [Homebrew](http://brew.sh)
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Install postgres
```
brew install postgresql
```
**Set postgres to load now and upon startup**
```
# To have launchd start postgresql at login:
ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents

# Start postgresal now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```
Install rbenv
```
brew install rbenv
brew install ruby-build
```
Add shims to ~/.bash_profile or ~/.profile
```
# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile
```
Install Ruby
```
rbenv install 2.1.3
rbenv global 2.1.3
ruby -v

#ruby 2.1.3p242 (2014-09-19 revision 47630) [x86_64-darwin14.0]
```
Install Rails
```
gem install rails -v 4.1.6
rbenv rehash
rails -v

# Rails 4.1.6
```
Fork and checkout [teamtrope-rails](https://github.com/Booktrope/teamtrope-rails)
```
git clone https://github.com/<your github username>/teamtrope-rails.git
```
Set local ruby interpreter for the project
```
cd teamtrope-rails
rbenv local 2.1.3
```
Install bundler and gems
```
gem install bundler
bundle install
```
Create your own secrets.yml file

The secrets.yml is not checked into the repo for security reasons. You can create your own secrets.yml one of two ways. Create a separate dummy project `rails new throwaway_project` and then copy the `config/secrets.yml` file into `teamtrope-rails`

The other way is to use the template below and replace the keys with your own by performing `rake secret` in the terminal.
```
# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use 698dff5042e5617d855f66e3e2991175fa87a73a927e8fd434da53c1d06ad1a083e20cdd9707966f54d13ef06ec4c36153a1f19e4f68357ca8aaa9cebda99ac9 to generate a secure secret key.

# Make sure the secrets in this file are kept private
# if you're sharing your code publicly.

development:
  secret_key_base: <paste results of rake secret here. Should be different than test.>

test:
  secret_key_base: <paste results of rake secret here. Should be different than development.>

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

Add your own config/application.yml

Create/Migrate/Populate DB
```
# create the db and seed it with data for test
rake db:create db:migrate db:seed admin_user=john.doe password=12341234

# populate the project grid table row table
rake teamtrope:populate_pgtr
```
Start Rails Server (using standard WEBrick or Unicorn)
```
#WEBrick (Serial, Great for development)
rails s

# or

#Unicorn (Concurrent, Not so great for dev since it doesn't print detailed logs to the console)
bundle exec unicorn -p 3000 -c ./config/unicorn.rb 
```
Confirm It worked
```
http://localhost:3000
```
Kill the server with CTRL-C

Install Redis

```
brew install redis
```

Start Redis
```
redis-server
```

Execute Rake Task to monitor the Redis Queue (If don't run the task the jobs will queue up without actually being run)
```
TERM_CHILD=1 QUEUE=signing_request,cancel_signing_request bundle exec rake resque:work
```

Start the server again 

Profit!!!!1