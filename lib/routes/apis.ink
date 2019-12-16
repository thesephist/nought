` json api paths `

std := load('../../vendor/std')
json := load('../../vendor/json')
db := load('../db').instance

ser := json.ser
de := json.de

personHandler := params => req => (
	personID := params.personID

    req.data.method :: {
        'GET' -> (req.end)({
            status: 200
            headers: {}
            body: ser((db.get)('person', {id: personID}))
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
    }
)

eventHandler := params => req => (
	eventID := params.eventID

    req.data.method :: {
        'GET' -> (req.end)({
            status: 200
            headers: {}
            body: 'event with ID ' + personID
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
    }
)

