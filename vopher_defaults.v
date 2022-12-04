module vopher

/*
** Simple implementation of the Gopher protocol with some extensions.
** (RFC 1436) for the V programming language.
** See https://datatracker.ietf.org/doc/html/rfc1436 for more details
**
** Licenced under the MIT licence.
*/

// Default values for the Gopher protocol

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

	vopher_types_to_str = {
		Vopher_types.text_file:        '0'
		Vopher_types.submenu:          '1'
		Vopher_types.ccso_nameserver:  '2'
		Vopher_types.error:            '3'
		Vopher_types.binhex_file:      '4'
		Vopher_types.dos_file:         '5'
		Vopher_types.uuencoded_file:   '6'
		Vopher_types.full_text_search: '7'
		Vopher_types.telnet:           '8'
		Vopher_types.binary_file:      '9'
		Vopher_types.mirror:           '+'
		Vopher_types.gif_file:         'g'
		Vopher_types.image_file:       'I'
		Vopher_types.telnet_3270:      'T'
		// Gopher+ types
		Vopher_types.bitmap_file:      ':'
		Vopher_types.movie_file:       ';'
		Vopher_types.sound_file:       '<'
		// Extensions
		Vopher_types.document_file:    'd'
		Vopher_types.html_file:        'h'
		Vopher_types.informationnal:   'i'
		Vopher_types.image_file:       'p'
		Vopher_types.rtf_file:         'r'
		// Same as `<`
		Vopher_types.sound_file:       's'
		Vopher_types.pdf_file:         'P'
		Vopher_types.xml_file:         'X'
	}

	vopher_default_terminator  = '.'

	vopher_default_line_return = '\r\n'

	vopher_default_separator   = '\t'
)
