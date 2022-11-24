module vopher

// Information line
fn test_simple_line() {
	line := 'iGeneric information\t\tnull.host\t1'
	out := parse_line(line) or {
		assert false
		return
	}
	assert out.gopher_type == Vopher_types.informationnal
}

// A simple empty line
fn test_empty_line() {
	line := ''
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}

// Valid but unknown type
fn test_unknown_type() {
	line := 'QUnknown type\t\tnull.host\t1'
	out := parse_line(line) or {
		assert false
		return
	}
	assert out.gopher_type == Vopher_types.unknown
	assert out.raw_type.ascii_str() == 'Q'
}

// Terminator line
fn test_terminator() {
	line := '.'
	out := parse_line(line) or {
		assert false
		return
	}
	assert out.gopher_type == Vopher_types.terminator
	assert out.raw_type.ascii_str() == '.'
}
