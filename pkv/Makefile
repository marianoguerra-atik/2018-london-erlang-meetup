BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/pkv
PRODRELPATH = _build/prod/rel/pkv
APPNAME = pkv
SHELL = /bin/bash

release:
	$(REBAR) release

console:
	cd $(RELPATH) && ./bin/pkv console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../pkv_config
	[ -f $(PRODRELPATH)/../pkv_config/pkv.conf ] || cp $(PRODRELPATH)/etc/pkv.conf  $(PRODRELPATH)/../pkv_config/pkv.conf
	[ -f $(PRODRELPATH)/../pkv_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../pkv_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/pkv console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release

devrel2:
	$(REBAR) as dev2 release

devrel3:
	$(REBAR) as dev3 release

devrel: devrel1 devrel2 devrel3

dev1-console:
	$(BASEDIR)/_build/dev1/rel/pkv/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/pkv/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/pkv/bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/pkv/bin/$(APPNAME) start; done

devrel-status:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/pkv/bin/$(APPNAME)-admin cluster members; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/pkv/bin/$(APPNAME)-admin cluster join pkv1@127.0.0.1; done
	for d in $(BASEDIR)/_build/dev{1,3}; do $$d/rel/pkv/bin/$(APPNAME)-admin cluster join pkv2@127.0.0.1; done
	for d in $(BASEDIR)/_build/dev{1,2}; do $$d/rel/pkv/bin/$(APPNAME)-admin cluster join pkv3@127.0.0.1; done

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/pkv/bin/$(APPNAME) ping; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/pkv/bin/$(APPNAME) stop; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

