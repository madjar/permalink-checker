permalink-checker
=================

permalink-checker takes an atom feed and check that every article
linked still exists. It helps check that the urls of your blog are not
broken after you migrate to another engine.


To use it, create a checklist file like this:

    $ permalink-checker atom http://compiletoi.net/feeds/all.atom.xml > checklist.yml

Then you can check the links whenever you want:

    $ permalink-checker check checklist.yml
    Checking http://compiletoi.net
    ✓ Atom file (/feeds/all.atom.xml)
    ✓ API wrappers: Danaïdes writing specifications (/api-wrappers-danaides-writing-specifications.html)
    ✓ This last few weeks in NixOS (/this-week-in-nixos-5.html)
    ✓ This couple of weeks in NixOS (/this-week-in-nixos-4.html)
    ✓ This Week in NixOS, third issue (/this-week-in-nixos-3.html)
    ✓ This Week in NixOS, second issue (/this-week-in-nixos-2.html)
    ✓ This Week in NixOS, first issue (/this-week-in-nixos-1.html)
    ✓ Fast scraping in python with asyncio (/fast-scraping-in-python-with-asyncio.html)
    ✓ Pyramid advanced configuration tactics for nice apps and libs (/pyramid-advanced-configuration-tactics-for-nice-apps-and-libs.html)
    ✓ Quick authentication on pyramid with persona (/quick-authentication-on-pyramid-with-persona.html)
    ✓ Good evening ladies and gentlemen, parlez vous français ? (/good-evening-ladies-and-gentlemen.html)

Features
--------

- Works with atom feed (RSS support could easily be added)
- Check the links of the article
- Check that the titles of the articles are actually in the page
- Color output!

Installation
------------

Install permalink-checker using ![stack](https://github.com/commercialhaskell/stack#readme) by running cloning the repo and running:

    stack install

License
-------

The project is licensed under the BSD3 license.
