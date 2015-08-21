permalink-checker
=================

permalink-checker takes an atom feed and check that every article
linked still exists. It helps check that the urls of your blog are not
broken after you migrate to another engine.

To use it, simply download the atom feed (keep it preciously if you migrate your blog), and pass it to permalink-checker:

    $ permalink-checker all.atom.xml
    ✓ This last few weeks in NixOS (http://compiletoi.net/this-week-in-nixos-5.html)
    ✓ This couple of weeks in NixOS (http://compiletoi.net/this-week-in-nixos-4.html)
    ✓ This Week in NixOS, third issue (http://compiletoi.net/this-week-in-nixos-3.html)
    ✓ This Week in NixOS, second issue (http://compiletoi.net/this-week-in-nixos-2.html)
    ✓ This Week in NixOS, first issue (http://compiletoi.net/this-week-in-nixos-1.html)
    ✓ Fast scraping in python with asyncio (http://compiletoi.net/fast-scraping-in-python-with-asyncio.html)
    ✓ Pyramid advanced configuration tactics for nice apps and libs (http://compiletoi.net/pyramid-advanced-configuration-tactics-for-nice-apps-and-libs.html)
    ✓ Quick authentication on pyramid with persona (http://compiletoi.net/quick-authentication-on-pyramid-with-persona.html)
    ✓ Good evening ladies and gentlemen, parlez vous français ? (http://compiletoi.net/good-evening-ladies-and-gentlemen.html)

Features
--------

- Works with atom feed (RSS support could easily be added)
- Check the links of the article
- Check the titles of the articles are actually in the page
- Color output!

Installation
------------

Install permalink-checker using ![stack](https://github.com/commercialhaskell/stack#readme) by running cloning the repo and running:

    stack install

License
-------

The project is licensed under the BSD3 license.
