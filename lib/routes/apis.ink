` json api paths `

std := load('../../vendor/std')
json := load('../../vendor/json')
db := load('../db').instance

ser := json.ser
de := json.de

` Person handlers `

personHandler := params => req => (
	personID := params.personID

	req.data.method :: {
		'GET' -> (req.end)({
			status: 200
			headers: {}
			body: ser((db.get)('person', {id: personID}))
		})
		'PUT' -> (req.end)({
			status: 201
			headers: {}
			body: ser((db.update)('person', {id: personID}))
		})
		'DELETE' -> (req.end)({
			status: 204
			headers: {}
			body: ser((db.remove)('person', {id: personID}))
		})
	}
)

allPersonHandler := _ => req => (
	req.data.method :: {
		'GET' -> (req.end)({
			status: 200
			headers: {}
			body: ser((db.ensureCollection)('person'))
		})
		'POST' -> (
			attrs := de(req.data.body)
			attrs :: {
				() -> (req.end)({
					status: 400
					headers: {}
					body: 'malformed data'
				})
				_ -> (req.end)({
					status: 201
					headers: {}
					body: ser((db.create)('person', attrs))
				})
			}
		)
	}
)

` Event handlers `

eventHandler := params => req => (
	eventID := params.eventID

	req.data.method :: {
		'GET' -> (req.end)({
			status: 200
			headers: {}
			body: 'event with ID ' + eventID
		})
		'PUT' -> (req.end)({
			status: 201
			headers: {}
			body: ser((db.update)('event', {id: eventID}))
		})
		'DELETE' -> (req.end)({
			status: 204
			headers: {}
			body: ser((db.remove)('event', {id: eventID}))
		})
	}
)

allEventHandler := _ => req => (
	req.data.method :: {
		'GET' -> (req.end)({
			status: 200
			headers: {}
			body: ser((db.ensureCollection)('event'))
		})
		'POST' -> (
			attrs := de(req.data.body)
			attrs :: {
				() -> (req.end)({
					status: 400
					headers: {}
					body: 'malformed data'
				})
				_ -> (req.end)({
					status: 201
					headers: {}
					body: ser((db.create)('event', attrs))
				})
			}
		)
	}
)

