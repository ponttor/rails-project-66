setup:
	bin/setup
	bin/rails db:fixtures:load

console:
	bin/rails console

seed:
	bin/rails db:fixtures:load

install:
	bundle install

test:
	bundle exec rake test

lint:
	bundle exec rubocop

correct:
	bundle exec rubocop -A

start:
	bin/rails s

env:
	Dotenv.load

.PHONY: test
