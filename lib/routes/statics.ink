` static paths `

tpl := load('../tpl')

handler := params => req => (
	staticPath := params.staticPath

	` return template resolved with vars `
	(req.end)({
		status: 200
		headers: {}
		body: 'statics test'
	})
)
