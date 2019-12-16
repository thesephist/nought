` templating library `

std := load('../vendor/std')

each := std.each
f := std.format
readFile := std.readFile

TPLROOT := './tpl/'
PARTS := [
	'parts/head'
]

` given a path to a template, prepare it
	for future use (cache it) `
prepare := path => (
	tpl := {
		content: '{{ missing template }}'
	}

	readFile(TPLROOT + path + '.html', s => tpl.content := s)
	each(PARTS, key => readFile(
		TPLROOT + key + '.html'
		s => tpl.content := f(tpl.content, key)
	))
)

` given a prepared template returned from prepare(),
	populate it with data and serialize into a string `
use := (prepared, data) => f(prepared.content, data)
