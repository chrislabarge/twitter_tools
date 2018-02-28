# Twitter Marketing Tool

A simple ruby library to perform daily marketing/social-networking related twitter tasks.

## Install

- Copy the '.env.example' file and name it '.env' `cp env.example .env`
- Fill out the '.env' file with the correct Twitter values
- Copy the 'config/.settings.example.yml' file and name it 'settings.yml' `cp config/settings.example.yml settings.yml`
- Overide the example terms in the 'settings.yml' with marketing search terms
- run `bundle install`

## Usage

You can run a series of rake commands to interact with your twitter account. Install this library on a machine capable of cron jobs to perform the rake tasks repeatedly.

  ### Rake Tasks

  - `rake follow_users[INTEGER]` - Follow Users of tweets that contain search terms you set in the 'config/settings.yml' file. Replace INTEGER with any integer to set the follow/user limit (default: 80).
  - `rake favorite_tweets[INTEGER]` - Favorite/Like tweets that contain search terms you set in the 'config/settings.yml' file. Replace INTEGER with any integer to set the favorite/like limit (default: 80).

## Author
 Website: [ChrisLaBarge.com](http://chrislabarge.com)

 Github: [github.com/chrislabarge](https://github.com/chrislabarge)
