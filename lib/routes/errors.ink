` error paths `

tpl := load('../tpl')

handler := () => req => (
	` return template resolved with vars `
	(req.end)({
		status: 404
		headers: {}
		body: 'could not be found'
	})
)

