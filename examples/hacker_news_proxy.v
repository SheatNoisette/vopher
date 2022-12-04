module main

import vopher
import net
import net.http
import json
import os

// Simple Gopher Proxy for Hacker News
// It is a simple example of how to use the vopher module and was not
// intended to be a full featured proxy.

const (
	hacker_news_api = 'https://hacker-news.firebaseio.com/v0/'
	max_news        = 10
)

struct Story {
	id    int
	title string
	url   string
}

fn (st Story) to_gopher_item() vopher.Vopher_item {
	return vopher.Vopher_item{
		gopher_type: vopher.Vopher_types.submenu
		user_display: st.title
		selector: ''
		host: st.title
		port: 80
	}
}

fn handle_client(mut socket net.TcpConn, page string) {
	client_addr := socket.peer_addr() or { return }
	eprintln('> new client: ${client_addr}')
	socket.write_string(page) or { return }
	socket.close() or { return }
}

fn main() {
	if os.args.len < 3 {
		eprintln('Usage: hnproxy <hostname> <port>')
		return
	}

	port := os.args[1]
	hostname := os.args[2]
	mut stories := []vopher.Vopher_item{}
	mut current_story := 0

	resp := http.get(hacker_news_api + 'topstories.json') or {
		println('Could not get top stories')
		return
	}
	ids := json.decode([]int, resp.body) or {
		println('failed to decode top stories')
		return
	}

	println('Getting top stories...')

	for id in ids {
		if current_story >= max_news {
			break
		}
		respo := http.get(hacker_news_api + 'item/' + id.str() + '.json') or {
			println('Could not get story ${id}')
			continue
		}
		story := json.decode(Story, respo.body) or {
			println('Could not decode story ${id}')
			continue
		}
		stories << story.to_gopher_item()
		current_story++
	}

	// Build a Vopher page
	gopher_page := vopher.build_page(stories) or {
		eprintln('Could not build page: ${err}')
		return
	}

	println('Done getting top stories, starting server...')

	mut server := net.listen_tcp(.ip, port + ':' + hostname)!
	laddr := server.addr()!
	eprintln('Listening on ${laddr} ...')

	for {
		mut socket := server.accept()!
		spawn handle_client(mut socket, gopher_page)
	}
}
