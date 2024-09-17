setup:
	bundle
	yarn install
	rails db:migrate

start-dev:
	rm -rf tmp/pids/server.pid
	bin/dev

check: test lint

lint:
	bundle exec rubocop -a
	bundle exec slim-lint app/views/

lint-force:
	bundle exec rubocop -A
	bundle exec slim-lint app/views/

test:
	bin/rails test

.PHONY: test
