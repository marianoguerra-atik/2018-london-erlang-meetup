BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/rckv
PRODRELPATH = _build/prod/rel/rckv
DEV1RELPATH = _build/dev1/rel/rckv
DEV2RELPATH = _build/dev2/rel/rckv
DEV3RELPATH = _build/dev3/rel/rckv
APPNAME = rckv
SHELL = /bin/bash

release:
	$(REBAR) release
	mkdir -p $(RELPATH)/../rckv_config
	[ -f $(RELPATH)/../rckv_config/rckv.conf ] || cp $(RELPATH)/etc/rckv.conf  $(RELPATH)/../rckv_config/rckv.conf
	[ -f $(RELPATH)/../rckv_config/advanced.config ] || cp $(RELPATH)/etc/advanced.config  $(RELPATH)/../rckv_config/advanced.config

console:
	cd $(RELPATH) && ./bin/rckv console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../rckv_config
	[ -f $(PRODRELPATH)/../rckv_config/rckv.conf ] || cp $(PRODRELPATH)/etc/rckv.conf  $(PRODRELPATH)/../rckv_config/rckv.conf
	[ -f $(PRODRELPATH)/../rckv_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../rckv_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/rckv console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release
	mkdir -p $(DEV1RELPATH)/../rckv_config
	[ -f $(DEV1RELPATH)/../rckv_config/rckv.conf ] || cp $(DEV1RELPATH)/etc/rckv.conf  $(DEV1RELPATH)/../rckv_config/rckv.conf
	[ -f $(DEV1RELPATH)/../rckv_config/advanced.config ] || cp $(DEV1RELPATH)/etc/advanced.config  $(DEV1RELPATH)/../rckv_config/advanced.config

devrel2:
	$(REBAR) as dev2 release
	mkdir -p $(DEV2RELPATH)/../rckv_config
	[ -f $(DEV2RELPATH)/../rckv_config/rckv.conf ] || cp $(DEV2RELPATH)/etc/rckv.conf  $(DEV2RELPATH)/../rckv_config/rckv.conf
	[ -f $(DEV2RELPATH)/../rckv_config/advanced.config ] || cp $(DEV2RELPATH)/etc/advanced.config  $(DEV2RELPATH)/../rckv_config/advanced.config

devrel3:
	$(REBAR) as dev3 release
	mkdir -p $(DEV3RELPATH)/../rckv_config
	[ -f $(DEV3RELPATH)/../rckv_config/rckv.conf ] || cp $(DEV3RELPATH)/etc/rckv.conf  $(DEV3RELPATH)/../rckv_config/rckv.conf
	[ -f $(DEV3RELPATH)/../rckv_config/advanced.config ] || cp $(DEV3RELPATH)/etc/advanced.config  $(DEV3RELPATH)/../rckv_config/advanced.config

devrel: devrel1 devrel2 devrel3

dev1-console:
	$(BASEDIR)/_build/dev1/rel/rckv/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/rckv/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/rckv/bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/rckv/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/rckv/bin/$(APPNAME)-admin cluster join rckv1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/rckv/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/rckv/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/rckv/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/rckv/bin/$(APPNAME) ping; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/rckv/bin/$(APPNAME) stop; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

