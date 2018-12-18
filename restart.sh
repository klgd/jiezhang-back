#!/bin/bash
kill -9 `cat tmp/pids/unicorn.pid`
bundle exec unicorn_rails -l 0.0.0.0:3000 -D -E production -c config/unicorn.rb
