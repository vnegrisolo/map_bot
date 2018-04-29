.PHONY: app-setup app-test

app-setup:
	mix deps.get
	mix compile

app-test: app-setup
	mix format
	mix credo
	mix test --trace
	mix dialyzer
