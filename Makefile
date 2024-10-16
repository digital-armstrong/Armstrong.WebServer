setup:
	bundle install
	yarn install
	yarn build
	yarn build:css
	bin/rails db:create db:migrate

start-dev:
	rm -rf tmp/pids/server.pid
	bin/dev

cleanup:
	bin/rails db:drop db:create db:migrate

check: test lint

lint:
	bundle exec rubocop -a
	bundle exec slim-lint app/views/

lint-force:
	bundle exec rubocop -A
	bundle exec slim-lint app/views/

test:
	bundle exec rake db:drop RAILS_ENV=test
	bundle exec rake db:create RAILS_ENV=test
	bundle exec rake db:schema:load RAILS_ENV=test
	bundle exec rspec spec --format documentation

.PHONY: test
