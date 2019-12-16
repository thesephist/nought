` templating library `

std := load('../vendor/std')

f := std.format
readFile := std.readFile

` given a path to a template, prepare it
	for future use (cache it) `
prepare := path => (
	tpl := {
		content: '{{ missing template }}'
	}

	readFile(path, s => tpl.content := s)
)

` given a prepared template returned from prepare(),
	populate it with data and serialize into a string `
use := (prepared, data) => f(prepared.content, data)
