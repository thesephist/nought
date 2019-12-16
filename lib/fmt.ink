` template formatting with {{ key }} constructs,
	copied from std and updated to leave unrecognized
	keys alone in the template `

format := (raw, values) => (
	` parser state `
	state := {
		` current position in raw `
		idx: 0
		` parser internal state:
			0 -> normal
			1 -> seen one {
			2 -> seen two {
			3 -> seen a valid } `
		which: 0
		` buffer for currently reading key `
		key: ''
		` result build-up buffer `
		buf: ''
	}

	` helper function for appending to state.buf `
	append := c => state.buf := state.buf + c

	` read next token, update state `
	readNext := () => (
		c := raw.(state.idx)

		state.which :: {
			0 -> c :: {
				'{' -> state.which := 1
				_ -> append(c)
			}
			1 -> c :: {
				'{' -> state.which := 2
				` if it turns out that earlier brace was not
					a part of a format expansion, just backtrack `
				_ -> (
					append('{' + c)
					state.which := 0
				)
			}
			2 -> c :: {
				'}' -> (
					` insert key value, but only if key is recognized `
					state.buf := state.buf + (values.(state.key) :: {
						() -> '{{' + state.key + '}}'
						_ -> string(values.(state.key))
					})
					state.key := ''
					state.which := 3
				)
				` ignore spaces in keys -- not allowed `
				' ' -> ()
				_ -> state.key := state.key + c
			}
			3 -> c :: {
				'}' -> state.which := 0
				` ignore invalid inputs -- treat them as nonexistent `
				_ -> ()
			}
		}

		state.idx := state.idx + 1
	)

	` main recursive sub-loop `
	max := len(raw)
	(sub := () => state.idx < max :: {
		true -> (
			readNext()
			sub()
		)
		false -> state.buf
	})()
)
