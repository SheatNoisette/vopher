module vopher

fn test_simple_line() {
	line := 'iGeneric information\t\tnull.host\t1'
	out := parse_line(line) or {
		assert false
		return
	}
	assert out.gopher_type == Vopher_types.informationnal
}

fn test_empty_line() {
	line := ''
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}
