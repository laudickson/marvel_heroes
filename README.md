This small app lets you add in your favorite Marvel superheroes such as as [Iron Man](https://en.wikipedia.org/wiki/Iron_Man), [Spider-Man](https://en.wikipedia.org/wiki/Spider-Man), [Thor](https://en.wikipedia.org/wiki/Thor_(Marvel_Comics)), [Captain America](https://en.wikipedia.org/wiki/Captain_America), and [Hulk](https://en.wikipedia.org/wiki/Hulk_(comics))!

Before you install:

This assumes you have [PostgreSQL])(http://www.postgresql.org) installed!

This also assumes that you have a [Marvel API account](http://developer.marvel.com/). If you don't, sign up! It's free.

Instructions:

  * clone or download this git

  * run `bundle install`

  * run `rake db:setup`

  * open the `.env` file in this project's root directory and add in your public key where it says `PUBLIC_KEY` and private key where it says `PRIVATE_KEY`. Both of these keys can be found from your [Marvel API account](http://developer.marvel.com/).

  * run `rails s`

  * go to `localhost:3000` on your favorite browser

  * Enter hero names!
