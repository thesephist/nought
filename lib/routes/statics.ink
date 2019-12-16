` static paths `

std := load('../../vendor/std')
tpl := load('../tpl')

each := std.each
prepare := tpl.prepare
use := tpl.use

TPLS := {
	index: ()
}

` prepare all registered templates `
each(keys(TPLS), name => TPLS.(name) := prepare(name))

handler := params => req => (
	staticPath := (params.staticPath :: {
		'' -> 'index'
		_ -> params.staticPath
	})

	` return template resolved with vars `
	TPLS.(staticPath) :: {
		() -> (req.end)({
			status: 404
			headers: {}
			body: 'template not registered'
		})
		_ -> (req.end)({
			status: 200
			headers: {}
			body: use(TPLS.(staticPath), {title: staticPath + '| nought'})
		})
	}
)

indexHandler := _ => req => (req.end)({
	status: 200
	headers: {}
	body: use(TPLS.index, {title: 'nought'})
})
