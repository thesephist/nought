` templating library `

std := load('../vendor/std')
fmt := load('fmt')

each := std.each
f := fmt.format
readFile := std.readFile

TPLROOT := './tpl/'
PARTS := [
	'parts/head'
	'parts/nav'
	'parts/footer'
]

` given a path to a template, prepare it
	for future use (cache it) `
prepare := path => (
	tpl := {
		content: '{{ missing template }}'
	}

	readFile(TPLROOT + path + '.html', s => (
		tpl.content := s
		each(PARTS, key => readFile(
			TPLROOT + key + '.html'
			s => (
				` kind of a hack to ensure that template parts resolved
					at different times concurrently will populate the right
					slots in the master template `
				replacements := {}
				each(PARTS, key => replacements.(key) := '{{' + key + '}}')
				replacements.(key) := s

				tpl.content := f(tpl.content, replacements)
			)
		))
	))

	tpl
)

` given a prepared template returned from prepare(),
	populate it with data and serialize into a string `
use := (prepared, data) => f(prepared.content, data)
