app-setup:
	mix deps.get
	mix compile

app-test:
	make app-setup
	mix credo
	mix test --trace
