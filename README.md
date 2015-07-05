# SSLfie

*Generate self-signed x.509 certificates for use with SSL/TLS*

Benefits at a glance:

- Supports multiple domain names in one cert with the [SubjectAltName field](https://en.wikipedia.org/wiki/SubjectAltName)
- Trivial to automate — the only required argument is a domain name
- Automatically set modern options by default (`-sha256`, `-utf8`)
- Easy to install `.deb` and `.rpm` packages

## Synopsis

    Usage: sslfie [OPTION]... DOMAIN [DOMAIN2]...

    Generate a self-signed x.509 certificate for use with SSL/TLS.

    Options:
      -o PATH -- output the cert to a file at PATH
      -k PATH -- output the key to a file at PATH
      -K PATH -- sign key at PATH (instead of generating a new one)
      -c CC   -- country code listed in the cert (default: XX)
      -s SIZE -- generate a key of size SIZE (default: 2048)
      -y N    -- expire cert after N years (default: 10)

## Installation

### Ubuntu and Linux Mint

    sudo add-apt-repository ppa:mkropat/ppa
    sudo apt-get update
    sudo apt-get install sslfie

### Debian and Friends

Download the `.deb` package from [Latest Releases](https://github.com/mkropat/sslfie/releases/latest).  Then run:

    sudo dpkg -i sslfie*.deb
    sudo apt-get install -f	# if there were missing dependencies

### CentOS and Friends

Download the `.rpm` package from [Latest Releases](https://github.com/mkropat/sslfie/releases/latest).  Then run:

    sudo yum localinstall sslfie*.noarch.rpm

### Standalone Script

Installation isn't required.  The `sslfie` script is entirely self-contained,
so you can just download it:

    curl -O https://raw.githubusercontent.com/mkropat/sslfie/master/sslfie
    chmod +x sslfie

Then run it like so:

    ./sslfie www.example.com example.com

## Example Usage

Generate a cert for *www.example.com*:

    $ sslfie -c US -o example.crt -k example.key www.example.com example.com

That's it.  You can use `openssl` to examine the generated certificate:

    $ openssl x509 -in example.crt -noout -text | less

Some key lines to look for are:

    Subject: C=US, CN=www.example.com

And:

    X509v3 Subject Alternative Name:
        DNS:www.example.com, DNS:example.com

## Inspiration

- [Certify](https://github.com/rtts/certify) — earlier command that functions very similarly
  - (I wrote `sslfie` from scratch because I needed something that could be automated)
- [Creating certificates with SANs using OpenSSL](http://andyarismendi.blogspot.com/2011/09/creating-certificates-with-sans-using.html) — example config file
- [How to generate self-signed cert by jww](http://stackoverflow.com/a/21494483) — good howto post
- [SSL howto by Tommy M. McGuire](http://www.crsr.net/Notes/SSL.html) — example of using environment variables in `openssl` config
