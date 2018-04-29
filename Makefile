.PHONY: app-setup app-test

app-setup:
	mix deps.get
	mix compile

app-test: app-setup
	mix format
	MIX_ENV=test mix credo
	mix test --trace
	MIX_ENV=test mix dialyzer
