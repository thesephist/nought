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
		body: 'api test'
	})
)
