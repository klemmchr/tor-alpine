# tor-alpine
[![Build Status](https://travis-ci.org/chris579/tor-alpine.svg?branch=master)](https://travis-ci.org/chris579/tor-alpine) [![](https://images.microbadger.com/badges/version/chris579/tor-alpine.svg)](https://hub.docker.com/r/chris579/tor-alpine) [![](https://images.microbadger.com/badges/image/chris579/tor-alpine.svg)](https://microbadger.com/images/chris579/tor-alpine "Get your own image badge on microbadger.com") ![https://hub.docker.com/r/chris579/tor-alpine](https://img.shields.io/docker/pulls/chris579/tor-alpine.svg) ![https://hub.docker.com/r/chris579/tor-alpine](https://img.shields.io/docker/stars/chris579/tor-alpine.svg) ![https://github.com/chris579/tor-alpine/blob/master/LICENSE](https://img.shields.io/github/license/chris579/tor-alpine.svg)

Simple, minimal and self updating docker image for Tor based on Alpine Linux.  
This image comes predefined for hidden service modes with SOCKS5 but can be configured easily to run as a bridge, relay or exit node. You can find example configs for that [here](#Advanced-Configuration).

## Ports
Ports are depending on your configuration.

## Volumes
`/var/lib/tor` - data directory  
`/etc/localtime:/etc/localtime` - for precise local time  
`/etc/tor/torrc.config` - to override the default config

## Getting started
### Installation
Up-to-date builds are available on [Docker Hub](https://hub.docker.com/r/chris579/tor-alpine). This image is build daily and published if a new version is available.

```
docker pull chris579/tor-alpine
```

### Quickstart
```
docker run --name tor -v ./data:/var/lib/tor -v /etc/localtime:/etc/localtime -p 127.0.0.1:9050:9050 chris579/tor-alpine
```

or if using docker-compose

```yaml
version: '2'
services:
  tor:
    image: chris579/tor-alpine
    container_name: tor
    ports:
     - "127.0.0.1:9050:9050"
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime
      - ./data:/var/lib/tor
```

This configuration will expose the SOCKS5 port to your local machine. You should not bind this port to a public network unless you know what you do.

### Advanced configuration
For relay modes the config needs to be adjusted. You can mount your own config file to `/etc/tor/torrc.config`.  

Replace `<yourEmail>` with a contact mail address. In case something is wrong with your node you will be contacted there. You might want to obscure the mail because it will be displayed and indexed in plain text by search engines.

Replace `<yourNickName>` with a nickname of your choice. You and others will be able to find the node with this name. This is helpful when you don't want to remember the fingerprint of your server when searching for it.

#### Bridge configuration
A tor brige is a not publically listed relay. It works like a normal relay but is especially suitable for situations when public tor relays are blocked in some way.

```
ORPort 9001
Nickname <yourNickName>
ContactInfo <yourEmail>
ExitRelay 0
ExitPolicy reject *:*
BridgeRelay 1
```

Make sure to expose port 9001  
`-p 9001:9001`

or if using docker-compose

```yaml
ports:
  - "9001:9001"
```

#### Middle relay
A middle relay is one of the first few relay traffic flows through. Due to the nature of Tor it is considered safe to host a middle relay. After some time your relay will also become available as a entry node if it is considered stable. Entry guards are a sensitive point in the Tor network as they are seeing the blank IPs of their users. You can read more about that [here](https://blog.torproject.org/lifecycle-new-relay). Most hosters are agreeing on providing a Tor relay on your server. 

```
ORPort 9001
Nickname <yourNickName>
ContactInfo <yourEmail>
ExitRelay 0
ExitPolicy reject *:*
```

Make sure to expose port 9001  
`-p 9001:9001`

or if using docker-compose

```yaml
ports:
  - "9001:9001"
```

#### Exit relay
An exit relay is the last point where traffic is running through. In exit mode your server will reach out into the internet, forwarding the original request of the user. This also means that possible law enforcement will just see your server accessing these resources. A lot of hosters are prohibiting/blocking exit relays because they fear prosecution. Before running an exit relay make sure to contact your hoster about his opinion to exit relays.

This sample configuration is using a reduced exit policy list. This limits the number of ports that can be used your node as an exit relay.
```
ORPort 9001
Nickname <yourNickName>
ContactInfo <yourEmail>

# Reduced exit policy from
# https://trac.torproject.org/projects/tor/wiki/doc/ReducedExitPolicy
ExitPolicy accept *:20-23     # FTP, SSH, telnet
ExitPolicy accept *:43        # WHOIS
ExitPolicy accept *:53        # DNS
ExitPolicy accept *:79-81     # finger, HTTP
ExitPolicy accept *:88        # kerberos
ExitPolicy accept *:110       # POP3
ExitPolicy accept *:143       # IMAP
ExitPolicy accept *:194       # IRC
ExitPolicy accept *:220       # IMAP3
ExitPolicy accept *:389       # LDAP
ExitPolicy accept *:443       # HTTPS
ExitPolicy accept *:464       # kpasswd
ExitPolicy accept *:465       # URD for SSM (more often: an alternative SUBMISSION port, see 587)
ExitPolicy accept *:531       # IRC/AIM
ExitPolicy accept *:543-544   # Kerberos
ExitPolicy accept *:554       # RTSP
ExitPolicy accept *:563       # NNTP over SSL
ExitPolicy accept *:587       # SUBMISSION (authenticated clients [MUA's like Thunderbird] send mail over STARTTLS SMTP here)
ExitPolicy accept *:636       # LDAP over SSL
ExitPolicy accept *:706       # SILC
ExitPolicy accept *:749       # kerberos
ExitPolicy accept *:873       # rsync
ExitPolicy accept *:902-904   # VMware
ExitPolicy accept *:981       # Remote HTTPS management for firewall
ExitPolicy accept *:989-995   # FTP over SSL, Netnews Administration System, telnets, IMAP over SSL, ircs, POP3 over SSL
ExitPolicy accept *:1194      # OpenVPN
ExitPolicy accept *:1220      # QT Server Admin
ExitPolicy accept *:1293      # PKT-KRB-IPSec
ExitPolicy accept *:1500      # VLSI License Manager
ExitPolicy accept *:1533      # Sametime
ExitPolicy accept *:1677      # GroupWise
ExitPolicy accept *:1723      # PPTP
ExitPolicy accept *:1755      # RTSP
ExitPolicy accept *:1863      # MSNP
ExitPolicy accept *:2082      # Infowave Mobility Server
ExitPolicy accept *:2083      # Secure Radius Service (radsec)
ExitPolicy accept *:2086-2087 # GNUnet, ELI
ExitPolicy accept *:2095-2096 # NBX
ExitPolicy accept *:2102-2104 # Zephyr
ExitPolicy accept *:3128      # SQUID
ExitPolicy accept *:3389      # MS WBT
ExitPolicy accept *:3690      # SVN
ExitPolicy accept *:4321      # RWHOIS
ExitPolicy accept *:4643      # Virtuozzo
ExitPolicy accept *:5050      # MMCC
ExitPolicy accept *:5190      # ICQ
ExitPolicy accept *:5222-5223 # XMPP, XMPP over SSL
ExitPolicy accept *:5228      # Android Market
ExitPolicy accept *:5900      # VNC
ExitPolicy accept *:6660-6669 # IRC
ExitPolicy accept *:6679      # IRC SSL
ExitPolicy accept *:6697      # IRC SSL
ExitPolicy accept *:8000      # iRDMI
ExitPolicy accept *:8008      # HTTP alternate
ExitPolicy accept *:8074      # Gadu-Gadu
ExitPolicy accept *:8080      # HTTP Proxies
ExitPolicy accept *:8082      # HTTPS Electrum Bitcoin port
ExitPolicy accept *:8087-8088 # Simplify Media SPP Protocol, Radan HTTP
ExitPolicy accept *:8332-8333 # Bitcoin
ExitPolicy accept *:8443      # PCsync HTTPS
ExitPolicy accept *:8888      # HTTP Proxies, NewsEDGE
ExitPolicy accept *:9418      # git
ExitPolicy accept *:9999      # distinct
ExitPolicy accept *:10000     # Network Data Management Protocol
ExitPolicy accept *:11371     # OpenPGP hkp (http keyserver protocol)
ExitPolicy accept *:19294     # Google Voice TCP
ExitPolicy accept *:19638     # Ensim control panel
ExitPolicy accept *:50002     # Electrum Bitcoin SSL
ExitPolicy accept *:64738     # Mumble
ExitPolicy reject *:*
```

Make sure to expose port 9001  
`-p 9001:9001`

or if using docker-compose

```yaml
ports:
  - "9001:9001"
```

### Liming the used bandwith
To have control over the bandwith and cpu load you can limit the used bandwith. Add this lines to your config:
```
BandwidthRate 10 Mbits
BandwidthBurst 12 Mbits
MaxAdvertisedBandwidth 9 Mbits
```

`MaxAdvertisedBandwidth` needs to be lower than `BandwidthRate`. It also indirectly limits the cpu load. By adjusting it you can fine tune the load of your server. You can find out more about these parameters (and every other config parameter) [here](https://www.torproject.org/docs/tor-manual.html.en).

### Seeing the results
When running in relay or exit mode your tor service should be picked up by the network after a couple of hours. You can then search for your node on [tormetrics](https://metrics.torproject.org/rs.html#search) (if it's not running as a bridge). The first days your Tor node will slowly increase traffic. The process how new relays are treated by the Tor network is described in this [blog post](https://blog.torproject.org/lifecycle-new-relay).

## Credits
Thanks to [Jessie Frazelle](https://blog.jessfraz.com/) for his [tutorial](https://blog.jessfraz.com/post/running-a-tor-relay-with-docker/) about Tor and Docker.

## License
MIT
