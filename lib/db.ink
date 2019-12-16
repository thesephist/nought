` json database abstraction `

std := load('../vendor/std')
json := load('../vendor/json')

readFile := std.readFile
writeFile := std.writeFile
ser := json.ser
de := json.de

DBPATH := './db.json'

new := () => (
	instance := {
		path: DBPATH
		data: {}
	}

	readFile(
		instance.path
		s => de(s) :: {
			` guard against failed reads, crash early `
			() -> (std.log)('Failed database Read!')
			_ -> instance.data := de(s)
		}
	)

	instance
)

` functions to be written `

ensureCollection := name => ()

create := (collection, attrs) => ()
update := (collection, attrs) => ()
get := (collection, attrs) => ()
where := (collection, attrs) => ()
delete := (collection, attrs) => ()
