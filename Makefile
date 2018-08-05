.PHONY: setup test

setup:
	mix deps.get
	mix compile

test: setup
	mix format
	MIX_ENV=test mix credo
	mix test --trace
	MIX_ENV=test mix dialyzer

docs: setup
	mix docs

deploy: test
	./bin/deploy
