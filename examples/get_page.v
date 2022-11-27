module main

import vopher
import net
import io
import os

fn main() {
	// Check the user has given a argument
	if os.args.len < 2 {
		eprintln('usage: <Gopher link>')
		return
	}

	// Make a new connection
	mut conn := net.dial_tcp(os.args[1] + ':70') or {
		eprintln('error: could not connect to ${os.args[1]}')
		return
	}
	defer {
		conn.close() or {}
	}

	// Ask the gopher server for the root
	conn.write_string('/\r\n')!

	// Get the response
	result := io.read_all(reader: conn)!
	page_str := result.bytestr()

	// Parse the response
	gopher := vopher.parse_page(page_str) or {
		eprintln('error: ${err}')
		return
	}

	html := vopher.generate_html(gopher) or {
		eprintln('error: ${err}')
		return
	}

	println(html)
}
