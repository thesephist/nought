` url router `

std := load('../vendor/std')
str := load('../vendor/str')

slice := std.slice
filter := std.filter
split := str.split

new := () => []

add := (router, pattern, handler) => router.len(router) := [pattern, handler]

` if path matches pattern, return a hash of matched params.
	else, return () `
matchPath := (pattern, path) => (
	desired := filter(split(pattern, '/'), s => ~(s = ''))
	actual := filter(split(path, '/'), s => ~(s = ''))

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

			(std.log)(desiredPart)
			(std.log)(actualPart)

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
match := (router, path) => (sub := i => (
	result := matchPath(router.(i).0, path)
	result :: {
		() -> i :: {
			len(router) -> req => (req.end)({
				status: 200
				headers: {}
				body: 'dropped route'
			})
			_ -> sub(i + 1)
		}
		_ -> (router.(i).1)(result)
	}
))(0)
