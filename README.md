# Vopher

![tests](https://github.com/SheatNoisette/vopher/actions/workflows/make.yml/badge.svg)

A simple library to parse Gopher pages from a Gopher server. Basic Gopher+
support is also included.

Originally written for a personal project, I decided to make it public in case
someone else might find it useful.

Please note that this library is still in development and is not yet ready for
production use. It is also not yet fully compliant with the Gopher+ protocol.

**The API is subject to change until it reaches the 0.1.0 version**

## Installation
```bash
$ v install --git https://github.com/SheatNoisette/vopher.git
```

## Quickstart
A simple example to get a Gopher page and parse it
```v
import vopher

import net
import io

// Make a new connection
mut conn := net.dial_tcp("a_gopher_site.com:70") ?

// Ask the gopher server for the root
conn.write_string('/\r\n')!

// Get the response
result := io.read_all(reader: conn)!
page_str := result.bytestr()

// Parse the response
gopher := vopher.parse_page(page_str) ?

// Print the parsed response
println(gopher)

// Close the connection
conn.close() ?
```
For more examples, see the `examples` directory.

## Documentation
Documentation can be generated using `v doc`:
```bash
$ v doc . -m -f html docs/
```

## Tests
Tests can be run using `v test`:
```bash
$ v -stats test .
```

## License
Licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
