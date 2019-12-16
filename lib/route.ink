` url router `

std := load('../vendor/std')
str := load('../vendor/str')

slice := std.slice
split := str.split

new := () => []

add := (router, pattern, handler) => router.len(router) := [pattern, handler]

` if path matches pattern, return a hash of matched params.
	else, return () `
matchPath := (pattern, path) => (
	desired := split(pattern, '/')
	actual := split(path, '/')

	max := (len(desired) > len(actual) :: {
		true -> len(desired)
		false -> len(actual)
	})

	params := {}
	(sub := i => i :: {
		max -> params
		_ -> (
			desiredPart := desired.(i)
			actualPart := actual.(i)

			desiredPart.0 :: {
				':' -> (
					params.(slice(desiredPart, 1, len(desiredPart))) := actualPart
					sub(i + 1)
				)
				_ -> desiredPart :: {
					actualPart -> sub(i + 1)
					_ -> ()
				}
			}
		)
	})(0)
)

` returns the proper handler curried with url params `
match := (router, path) => (
	result := matchPath(patterns.(i).0, path)
	(sub := i => result :: {
		() -> i :: {
			len(router) -> ()
			_ -> sub(i + 1)
		}
		_ -> (patterns.(i).1)(result)
	})(0)
)
