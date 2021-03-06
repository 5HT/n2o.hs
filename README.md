N2O: Haskell Web Framework [![Build Status](https://secure.travis-ci.org/nponeccop/n2o.hs.png?branch=master)](http://travis-ci.org/nponeccop/n2o.hs)
==========================

A Haskell port of the N2O Erlang Application Server: http://synrc.github.io/n2o/


Support:

* [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/nponeccop/n2o.hs?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
* IRC Channel #n2o on FreeNode 24/7

Introduction
------------

The eponymous N2O protocol is an innovative Javascript RPC where client state is moved to the server. 

The server pushes chunks of javascript code to client which get evaluated there. The client pushes browser clicks to the server to the handled there. Achieved statelessness of client code obviates such things as synchronization of client-side models with the server, and dramatically reduces client code size. After all, we want to program as little as possible in such a poor language as 
Javascript, and more in Erlang or Haskell.

The idea has been field-tested in large-scale deployments in such areas as online banking and online card games, and contrary to intuition, shows excellent user-perceived performance.

Client Architecture
-------------------

### Receiving events from the server

There is no such thing as installation of handlers of server events. Instead, the server can command browser to execute arbitrary Javascript code. In practice it means that small pieces of code are generated on server, such as `qi('myelementid').innerHTML = '<p>bar</p>'`, so there is no need to synchronize client-side code with server-side changes: some client code is effectively moved to the server.

### Sending events to the server

The sending is unidirectional, just like the receiving: there are no need to wait for 'RPC return value' or analogs. So typical client code is just `ws.send(enc(tuple(atom('FOOEVENT'),bin(qi('myelementid').value))))` - some data are collected and sent, that's it. Typically there are no callbacks, loops or conditions.

Features
--------

Small and efficient protocol stack. Code size is one of the features we are proud of:

```
$ cloc static src/Network/N2O* | tail -n+6 | sed s/--*// | column -t
Language    files  blank  comment  code
JavaScript  6      29     10       147
Haskell     2      47     6        138
SUM:        8      76     16       285
```

The protocol is binary compatible with [original N2O protocol](http://5ht.co/n2o.htm). The browser part is taken as is from the Erlang version. However, the server implements only a subset of the upstream features (shown in **bold**). Basically it's BERT over Websockets only. See the upstream documentation for terminology.

* Formatters: TEXT, JSON, XML, **BERT**, MessagePack
* Protocols: **heart**, spa, bin, nitrogen, bpe, mq, roster, muc, rest, search
* Endpoints: gen_server, **ws**, http
* PubSub: Built-in
* Persistence: None
* DOM Language: None


Mac OS X
--------

For quickstart you need `Git` for retrieving sources, glorious `Haskell` compiler, Static Web Server `webfsd`, `Casper.js` which run on top of headless v8 `Phantom.js`:

```
   $ brew install ghc
   $ brew install cabal-install
   $ brew install webfs
   $ npm install -g casperjs
   $ git clone http://github.com/nponeccop/n2o.hs && cd n2o.hs
   $ cabal update
   $ cabal install
   $ webfsd
   $ dist/build/n2o/n2o
   $ open http://localhost:8000/sample/client.html
   $ casperjs test tests
```

Arch Linux
----------

The library and the example chat server:
```
   $ pacman -Sy --needed git ghc cabal-install webfs
   $ git clone http://github.com/nponeccop/n2o.hs && cd n2o.hs
   $ cabal update
   $ cabal install
   $ webfsd
   $ nohup dist/build/n2o/n2o &
   $ open http://localhost:8000/sample/client.html
```
The PhantomJS headless browser tests:
```
   $ pacman -S --needed npm phantomjs
   $ npm install casperjs
   $ open http://localhost:8000/sample/client.html
   $ node_modules/.bin/casperjs test tests
```

Windows
-------

For quickstart you need at least GHC via [MinGHC](https://github.com/fpco/minghc/releases/download/2015-12-04/minghc-7.10.2-x86_64.exe) and `Git`. In `git bash` do:

```
   $ git clone http://github.com/nponeccop/n2o.hs && cd n2o.hs
   $ stack build
```

Run `n2o.exe` and `StaticWebServer.exe` and open http://localhost:8000/sample/client.html in your browser.

Credits
-------

* Andy Melnikov
* Maxim Sokhatsky
