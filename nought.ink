#!/usr/bin/env ink

` nought, @thesephist's personal crm `

std := load('vendor/std')

log := std.log
f := std.format

route := load('lib/route')
providers := {
	statics: load('lib/routes/statics')
	apis: load('lib/routes/apis')
	errors: load('lib/routes/errors')
}

PORT := 9220

log('Nought starting...')

` attach routes `
router := (route.new)()
add := (url, handler) => (route.add)(router, url, handler)
add('/static/:staticPath', providers.statics.handler)
add('/api/person/:personID', providers.apis.personHandler)
add('/api/event/:eventID', providers.apis.eventHandler)
add('/api/:apiPath', providers.apis.handler)
add('/', providers.statics.indexHandler)
add('/:blank', providers.errors.handler)

` start http server `
close := listen('0.0.0.0:' + string(PORT), evt => evt.type :: {
	'error' -> log('server error: ' + evt.message)
	'req' -> (
		log(f('{{ method }}: {{ url }}', evt.data))

		` normalize path `
		url := trimQP(evt.data.url)

		` respond to file request `
		match := (route.match)(router, url)
		evt.data.method :: {
			'GET' -> match(evt)
			'POST' -> match(evt)
			'PUT' -> match(evt)
			'DELETE' -> match(evt)
			_ -> (
				` if other methods, just drop the request `
				log('  -> ' + evt.data.url + ' dropped')
				(evt.end)({
					status: 405
					headers: hdr({})
					body: 'method not allowed'
				})
			)
		}
	)
})

` prepare standard header `
hdr := attrs => (
	base := {
		'X-Served-By': 'ink-serve'
		'Content-Type': 'text/plain'
	}
	each(keys(attrs), k => base.(k) := attrs.(k))
	base
)

` trim query parameters `
trimQP := path => (
	max := len(path)
	(sub := (idx, acc) => idx :: {
		max -> path
		_ -> path.(idx) :: {
			'?' -> acc
			_ -> sub(idx + 1, acc + path.(idx))
		}
	})(0, '')
)
