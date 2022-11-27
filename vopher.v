module vopher

import strconv

/*
** Simple implementation of the Gopher protocol with some extensions.
** (RFC 1436) for the V programming language.
** See https://datatracker.ietf.org/doc/html/rfc1436 for more details
**
** Licenced under the MIT licence.
*/

const (
	vopher_str_to_types = {
		'0': Vopher_types.text_file
		'1': Vopher_types.submenu
		'2': Vopher_types.ccso_nameserver
		'3': Vopher_types.error
		'4': Vopher_types.binhex_file
		'5': Vopher_types.dos_file
		'6': Vopher_types.uuencoded_file
		'7': Vopher_types.full_text_search
		'8': Vopher_types.telnet
		'9': Vopher_types.binary_file
		'+': Vopher_types.mirror
		'g': Vopher_types.gif_file
		'I': Vopher_types.image_file
		'T': Vopher_types.telnet_3270
		// Gopher+ types
		':': Vopher_types.bitmap_file
		';': Vopher_types.movie_file
		'<': Vopher_types.sound_file
		// Extensions
		'd': Vopher_types.document_file
		'h': Vopher_types.html_file
		'i': Vopher_types.informationnal
		'p': Vopher_types.image_file
		'r': Vopher_types.rtf_file
		// Same as `<`
		's': Vopher_types.sound_file
		'P': Vopher_types.pdf_file
		'X': Vopher_types.xml_file
	}

	vopher_default_terminator  = '.'

	vopher_default_line_return = '\r\n'

	vopher_default_separator   = '\t'
)

// Basic types for Gopher protocol
enum Vopher_types {
	unknown // Special type if something goes wrong
	terminator // Special type for the terminator '.'
	text_file
	submenu
	ccso_nameserver
	error
	binhex_file
	dos_file
	uuencoded_file
	full_text_search
	telnet
	binary_file
	mirror
	gif_file
	image_file
	telnet_3270
	// Gopher+
	bitmap_file
	movie_file
	sound_file
	// Extensions
	informationnal
	document_file
	html_file
	pdf_file
	rtf_file
	xml_file
}

// A basic Gopher item, representing a line in a Gopher page
struct Vopher_item {
	gopher_type  Vopher_types // type of item
	user_display string       // user display string
	selector     string       // selector string
	host         string       // host name
	port         int // port number
	// Advanced usage
	raw_string string // The full line from the server
	raw_type   string // The type as a string
}

// Custom line parsing struct
struct Vopher_line_parser {
	terminator  string // The terminator string
	line_return string // The line return string
	separator   string // The separator string
}

// Parse a line with a custom separator, line return and terminator
pub fn parse_line_custom(line string, separator string, line_return string, terminator string) !Vopher_item {
	// Get the first character
	if line.len == 0 {
		return error('vopher: empty line')
	}

	// Get the first character and split the line
	// This should be improved to support Gopher+/Gemini and other extensions
	first_char := line[0].ascii_str()

	// Check if it's a terminator
	if first_char == terminator {
		return Vopher_item{
			gopher_type: Vopher_types.terminator
			raw_string: line
			raw_type: first_char
		}
	}

	rest := line[1..]

	// Split the line into fields
	fields := rest.split(separator)

	// Check if the line is valid
	if fields.len < 3 {
		return error('vopher: invalid line - got ${fields.len} fields, expected at least 3')
	}

	// Try to get the type
	gopher_type := match first_char !in vopher_str_to_types {
		true { Vopher_types.unknown }
		false { vopher_str_to_types[first_char] }
	}

	// Parse port
	port := strconv.atoi(fields[3]) or { return error('vopher: invalid port number - ${err}') }

	return Vopher_item{
		gopher_type: gopher_type
		user_display: fields[0]
		selector: fields[1]
		host: fields[2]
		port: port
		raw_string: line
		raw_type: first_char
	}
}

// Parse a Gopher line into a Vopher_item struct using default Gopher values
pub fn parse_line(input string) !Vopher_item {
	return parse_line_custom(input, vopher_default_separator, vopher_default_line_return,
		vopher_default_terminator)
}

// Custom line parsing
pub fn parse_page_custom(input string, parser Vopher_line_parser) ![]Vopher_item {
	mut items := []Vopher_item{}
	lines := input.split(parser.line_return)
	for line in lines {
		if line.len == 0 {
			continue
		}
		item := parse_line(line) or { return error('vopher: ${err} - line : \'${line}\'') }
		items << item
	}
	return items
}

// Parse a Gopher page into a list of Vopher_item
pub fn parse_page(input string) ![]Vopher_item {
	return parse_page_custom(input, Vopher_line_parser{
		terminator: vopher_default_terminator
		line_return: vopher_default_line_return
		separator: vopher_default_separator
	})
}
