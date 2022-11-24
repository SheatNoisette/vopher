module vopher

/*
** Generate a HTML page from a Gopher document
**
** Licenced under the MIT licence.
** @TODO: This could be done better, but it works.
*/

// Generate a HTML page from a list of Gopher items
pub fn generate_html(items []Vopher_item) ?string {
	mut html := '<!DOCTYPE html>'
	html += '<html>'
	html += '<head>'
	html += '<meta charset="utf-8">'
	html += '<title>Vopher Page</title>'
	html += '</head>'
	html += '<body>'

	for e in items {
		html += generate_html_tag(e) or { return error('Failed to generate HTML tag - ${err}') }
		html += '\n'
	}

	html += '</body>'
	html += '</html>'
	return html
}

// Generate a HTML tag from a Gopher item
pub fn generate_html_tag(item Vopher_item) ?string {
	mut tag := ''

	// Check if it's a terminator or unknown type
	if item.gopher_type == .terminator || item.gopher_type == .unknown {
		return tag
	}

	tag += match item.gopher_type {
		.informationnal, .error {
			'<p>${item.user_display}</p>'
		}
		.text_file, .submenu {
			'<ul><a href="${item.selector}">${item.user_display}</a></ul>'
		}
		else {
			''
		}
	}

	return tag
}

// Generate a HTML page from a Gopher document
pub fn generate_html_from_gopher(document string) ?string {
	page_parsed := parse_page(document) or { return error('Could not parse the page') }
	return generate_html(page_parsed)
}
