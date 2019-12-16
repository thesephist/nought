` static paths `

std := load('../../vendor/std')
tpl := load('../tpl')

each := std.each
readFile := std.readFile
prepare := tpl.prepare
use := tpl.use

TPLS := {
	index: ()
}

STATICS := [
	'css/main.css'
	'js/main.js'
]

` prepare all registered templates `
each(keys(TPLS), name => TPLS.(name) := prepare(name))

handler := params => req => (
	staticPath := (params.staticPath :: {
		'' -> 'index'
		_ -> params.staticPath
	})

	` return template resolved with vars `
	TPLS.(staticPath) :: {
		() -> handleStatics(params)(req)
		_ -> (req.end)({
			status: 200
			headers: {}
			body: use(TPLS.(staticPath), {title: staticPath + ' | nought'})
		})
	}
)

handleStatics := params => req => (
	staticPath := params.staticPath
	(sub := i => STATICS.(i) :: {
		staticPath -> readFile(tpl.TPLROOT + STATICS.(i), s => s :: {
			() -> (req.end)({
				status: 500
				headers: {}
				body: 'error reading file'
			})
			_ -> (req.end)(({
				status: 200
				headers: {}
				body: s
			}))
		})
		_ -> sub(i + 1)
		() -> (req.end)({
			status: 404
			headers: {}
			body: 'template not registered'
		})
	})(0)
)

indexHandler := _ => req => (req.end)({
	status: 200
	headers: {}
	body: use(TPLS.index, {title: 'nought'})
})
