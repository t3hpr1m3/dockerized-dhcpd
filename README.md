# dhcpd

Simple docker image for running [dhcpd](http://www.isc.org/downloads/dhcp/) in a container.

## Usage

The image assumes that, at the very least, the `dhcpd.conf` file will be
mounted at `/srv/dhcpd/etc/dhcpd.conf`.  A more robust approach would be to
mount a directory at `/srv/dhcpd` containing subdirectories like `etc`, `var`,  and
`log`, allowing the container to share status information with the host.

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT).
