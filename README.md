# SSLfie

*Generate self-signed x.509 certificates for use with SSL/TLS*

Benefits at a glance:

- Supports multiple domain names in one cert with the [SubjectAltName field](https://en.wikipedia.org/wiki/SubjectAltName)
- Trivial to automate — the only required argument is a domain name

## Synopsis

    Usage: sslfie [OPTION]... DOMAIN [DOMAIN2]...

    Generate a self-signed x.509 certificate for use with SSL/TLS.

    Options:
      -o PATH -- output the cert to a file at PATH
      -k PATH -- output the key to a file at PATH
      -c CC   -- country code listed in the cert (default: XX)
      -s SIZE -- generate a key of size SIZE (default: 2048)
      -y N    -- expire cert after N years (default: 10)

## Inspiration

- [Certify](https://github.com/rtts/certify) — earlier command that functions very similarly
  - (I wrote `sslfie` from scratch because I needed something that could be automated)
- [Creating certificates with SANs using OpenSSL](http://andyarismendi.blogspot.com/2011/09/creating-certificates-with-sans-using.html) — example config file 
- [How to generate self-signed cert by jww](http://stackoverflow.com/a/21494483) — good howto post
- [SSL howto by Tommy M. McGuire](http://www.crsr.net/Notes/SSL.html) — example of using environment variables in `openssl` config
