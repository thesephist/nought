# Nought

Personal people-manager, what some people might call a personal CRM, written in [Ink](https://github.com/thesephist/ink)

## Internal Ink libraries and abstractions

This is the first nontrivial web application I'm building in Ink. As such, I'm writing a lot of libraries and abstractions useful for writing web applications, like routing and ORM concepts, as I go.

### Routing and server abstractions

```ink
router := (route.new)()
add := (url, handler) => (route.add)(router, url, handler)
add('/static/:staticPath', providers.statics.handler)
add('/api/person/:personID', providers.apis.personHandler)
add('/api/event/:eventID', providers.apis.eventHandler)
add('/api/:apiPath', providers.apis.handler)
add('/', providers.statics.indexHandler)
add('/:blank', providers.errors.handler)

` later in the server ... `
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
```

### Database abstractions

```ink
log := load('vendor/std').log
d := load('lib/db').instance

(d.create)('person', {name: 'Stephen Strange', age: 42, hero: true})
log(d.data)

(d.create)('person', {name: 'Linus Lee', age: 21})
log(d.data)

(d.update)('person', {age: 42}, {age: 32, name: 'Nick Fury'})
(d.create)('person', {name: 'Tony Stark', age: 42, hero: true})
log(d.data)

query := (d.where)('person', {age: 42})
log(query)

(d.remove)('person', {hero: true})
log(d.data)
```
