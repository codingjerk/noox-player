BIN = ./node_modules/.bin

deps:
	@npm i --no-save coffeescript
	@npm i --no-save express

	@npm i --no-save mocha
	@npm i --no-save chai
	@npm i --no-save request

MOCHA_EXCLUDE?=@skip
MOCHA_REPORTER?=spec

MOCHA_OPTS?=\
	--reporter ${MOCHA_REPORTER} \
	--grep ${MOCHA_EXCLUDE} --invert \
	--require coffeescript/register \
	spec/**/*.coffee

test:
	@${BIN}/mocha ${MOCHA_OPTS}

start:
	@${BIN}/coffee src/server.coffee

watch:
	@${BIN}/nodemon -q --ext 'coffee' --exec "clear; MOCHA_EXCLUDE=@slow MOCHA_REPORTER=min make -s test && make -s start || true"
