web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

resque: env TERM_CHILD=1 QUEUE=signing_request,cancel_signing_request bundle exec rake resque:work
