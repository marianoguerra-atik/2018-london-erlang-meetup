pkv
===========

A partisan application

Build
-----

::

    rebar3 release

Test
----

::

    rebar3 ct

Run
---

::

    rebar3 run

Clustering
----------

::

    make devrel

    # on 3 different shells
    make dev1-console
    make dev2-console
    make dev3-console

    # join all nodes:
    make devrel-join

    # check node members
    make devrel-status

    # join node1 to node2 manually:
    ./_build/dev1/rel/pkv/bin/pkv-admin cluster join pkv2@127.0.0.1

    # check node1 members
    ./_build/dev1/rel/pkv/bin/pkv-admin cluster members

    # check node1 connections
    ./_build/dev1/rel/pkv/bin/pkv-admin cluster connections

Ping node2 from node1 using partisan::

    1> pkv:ping('pkv2@127.0.0.1').
    ok

    % check logs/console on node2, you should see:
    got msg ping

.. code-block: erlang

    Bucket = <<"mybucket">>.
    Key1 = <<"mykey">>.
    Val1 = <<"myvalue">>.

    pkv:get(Bucket, Key1).
    % {ok,[]}

    pkv:set(Bucket, Key1, Val1).
    % ok

    pkv:get(Bucket, Key1).
    % {ok,[['pkv1@127.0.0.1',<<"myvalue">>]]}

Quit
----

::

    1> q().

TODO
----

* define license and create LICENSE file

License
-------

TODO
