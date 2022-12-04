module main

import vopher
import os

fn main() {
	if os.args.len != 1 {
		println('No arguments needed')
		return
	}

	// Get from stdin
	line := os.get_line()
	parse := vopher.parse_line(line) or {
		println('Error parsing line: ${err}')
		exit(1)
	}

	println('Parsed line: ${parse}')
}
