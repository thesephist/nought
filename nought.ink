#!/usr/bin/env ink

` nought, @thesephist's personal crm `

std := load('vendor/std')

log := std.log
f := std.format

route := load('lib/route')
providers := {
	statics: load('lib/routes/statics')
	api: load('lib/routes/api')
	errors: load('lib/routes/errors')
}

PORT := 9220

log('Nought starting...')

` attach routes `
router := (route.new)()
(route.add)(router, '/static/:staticPath', providers.statics.handler)
(route.add)(router, '/api/:apiPath', providers.api.handler)
(route.add)(router, '/:blank', providers.errors.handler)

close := listen('0.0.0.0:' + string(PORT), evt => evt.type :: {
	'error' -> log('server error: ' + evt.message)
	'req' -> (
		log(f('{{ method }}: {{ url }}', evt.data))

		` normalize path `
		url := trimQP(evt.data.url)

		` respond to file request `
		evt.data.method :: {
			'GET' -> (route.match)(router, url)(evt)
			'POST' -> (route.match)(router, url)(evt)
			'PUT' -> (route.match)(router, url)(evt)
			'DELETE' -> (route.match)(router, url)(evt)

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
