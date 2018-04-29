app-setup:
	mix deps.get
	mix compile

app-test:
	make app-setup
	mix format
	mix credo
	mix test --trace
	mix dialyzer
