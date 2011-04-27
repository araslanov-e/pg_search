# Simple working example of PostgreSQL Tsearch with Rails 3

Example code to get you up and started with the built-in FTS (Full Text Search)
feature of PostgreSQL >= 8.3

## Setup

1. At the command prompt, create the database
    rake db:create

2. Run the migrations:
    rake db:migrate

3. Populate with seed data:
    rake db:data:load   ->   Load contents of db/data.yml into the database

4. Grab those gems
    bundle install

5. Start the dev server
    rails s

## Suggested searches
Try entering the following in to the search textbox (without quotes):

1. 'hot' - Demonstrates ranking through word proximity, weighting & number of occurrences
3. 'monkeys' - As above
2. 'hot monkeys' - Demonstrates understanding of english pluralization, weighting

## More information
PostgreSQL Full Text Search docs are here: http://www.postgresql.org/docs/9.0/static/textsearch.html