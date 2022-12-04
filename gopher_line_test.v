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
	assert out.raw_type == 'Q'
}

// Terminator line
fn test_terminator() {
	line := '.'
	out := parse_line(line) or {
		assert false
		return
	}
	assert out.gopher_type == Vopher_types.terminator
	assert out.raw_type == '.'
}

// Invalid port
fn test_invalid_port() {
	line := 'iInvalid port\t\tnull.host\tinvalid'
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}

// Not a valid line
fn test_invalid_line() {
	line := 'I dont know what I am doing'
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}

// Valid selector but invalid line
fn test_invalid_line2() {
	line := 'iInvalid line'
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}

// Valid line but use spaces instead of tabs
fn test_spaces() {
	line := 'iSpaces ok null.host 1'
	out := parse_line(line) or {
		assert true
		return
	}
	assert false
}
