module vopher

fn compare_no_raw_vopheritem(a Vopher_item, b Vopher_item) bool {
	if a.gopher_type != b.gopher_type {
		return false
	}
	if a.user_display != b.user_display {
		return false
	}
	if a.selector != b.selector {
		return false
	}
	if a.host != b.host {
		return false
	}
	if a.port != b.port {
		return false
	}
	return true
}

fn test_information_into_gopher() {
	value := Vopher_item{
		gopher_type: Vopher_types.informationnal
		user_display: 'test'
		selector: 'test'
		host: 'test'
		port: 70
	}
	content := value.to_gopher() or { panic(err) }
	assert content == 'itest\ttest\ttest\t70\r\n'
}

fn test_bidirectionnal_into_gopher() {
	value := Vopher_item{
		gopher_type: Vopher_types.informationnal
		user_display: 'test'
		selector: 'test'
		host: 'test'
		port: 70
	}
	content := value.to_gopher() or { panic(err) }
	parsed := from_gopher(content) or { panic(err) }
	assert compare_no_raw_vopheritem(parsed, value)
}
