` json api paths `

std := load('../../vendor/std')
json := load('../../vendor/json')
db := load('../db')

handler := params => req => (
	apiPath := params.apiPath

	` return data from database `
	(req.end)({
		status: 200
		headers: {}
		body: 'api test at path ' + apiPath
	})
)

personHandler := params => req => (
	personID := params.personID

	(req.end)({
		status: 200
		headers: {}
		body: 'person with ID ' + personID
	})
)

eventHandler := params => req => (
	eventID := params.eventID

	(req.end)({
		status: 200
		headers: {}
		body: 'event with ID ' + eventID
	})
)
