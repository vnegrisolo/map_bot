#!make
.PHONY: help console docs deploy outdated setup test update-mix

HELP_PADDING = 20

help: ## Shows this help.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\$$//'`); \
	for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-$(HELP_PADDING)s %s\n" $$help_command $$help_info ; \
	done

console: ## Opens the App console.
	iex -S mix

outdated: ## Shows outdated packages.
	mix hex.outdated
	npm --prefix=assets/ outdated

setup: ## Setup the App.
	mix deps.get
	mix compile

test: ## Run the test suite.
test: setup
	mix format
	MIX_ENV=test mix credo
	mix test --trace --cover
	MIX_ENV=test mix dialyzer

docs: ## Generate documentation.
docs: setup
	mix docs

deploy: ## Deploy into hex.pm
deploy: test
	version=`mix run -e 'IO.puts(Mix.Project.config()[:version])'`; \
	git tag -a $${version} -m "Release $${version}"
	git push origin --tags
	echo "=> You'll have to input you local pass for hex"
	mix hex.user whoami
	mix hex.build
	mix hex.publish

update-mix: ## Update mix packages.
	mix deps.update --all
