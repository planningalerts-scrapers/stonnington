STONNINGTON
===========

This is a scraper that runs on [Morph](https://morph.io). To get started [see the documentation](https://morph.io/documentation)

Add any issues to https://github.com/planningalerts-scrapers/issues/issues

## To run the scraper

    bundle exec ruby scraper.rb

Optionally prefix with DEBUG=1 to see debug output

### Expected output

    Saving record 0189/26 - 500 CHAPEL STREET, SOUTH YARRA VIC 3141
    Saving record 0185/26 - 72 OBAN STREET, SOUTH YARRA VIC 3141
    ...
    Saving record 0136/26 - 229-231 GLENFERRIE ROAD, MALVERN VIC 3144
    Saving record 0852/18 - SC4 - 225 WAVERLEY ROAD, MALVERN EAST VIC 3145
    Page 1: 100 records received from 2026-03-12 (continuing on next page)
    /home/ianh/.local/share/mise/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/mechanize-2.8.5/lib/mechanize/pluggable_parsers.rb:107:in `new': MIME::Type.MIME::Type.new when called with a String is deprecated.
    Saving record 1275/16 - PC6 - 599 & 601 Dandenong Road, Armadale VIC 3143
    Saving record 0135/26 - 38 LORNE ROAD, PRAHRAN VIC 3181
    ...
    Saving record 0079/26 - 53 & 55 ALFRED STREET, PRAHRAN VIC 3181
    Saving record 0086/26 - 866 HIGH STREET, ARMADALE VIC 3143
    Page 2: 100 records received from 2026-02-19 (far enough into past)
    Done. Total saved: 200
    
    Process finished with exit code 0

Execution time ~ 10 seconds

## To run style and coding checks

    bundle exec rubocop

## To check for security updates

    gem install bundler-audit
    bundle-audit
