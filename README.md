# Multicultural Association of Business Students (MABS) Tracker

## Description

The Multicultural Association of Business Students (MABS) Event Scheduler is a web application designed to streamline event scheduling for the organization. It allows organizers to efficiently plan and manage events, while members can earn points for attending, fostering a sense of engagement and competition within the organization.

## Features

- **Event Scheduling:** Easily create and schedule events for the organization.
- **Attendance Points:** Members earn points for attending events, promoting active participation.
- **Leaderboard:** A leaderboard displays member standings based on attendance points.
- **User Profiles:** Members can view their own profiles, track attendance, and see their rankings.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Testing](#testing)
- [Contributors](#contributors)

## Requirements

**Environment**:
- Ubuntu (specify version)
- Docker Engine (specify version)
- Docker Container (specify version)
- Heroku (specify version)
- Node.js (specify version)
- Yarn (specify version)
- Other necessary environment specifics

**Program**:
- rake 13.1.0
- concurrent-ruby 1.2.3
- i18n 1.14.1
- minitest 5.22.0
- tzinfo 2.0.6
- activesupport 7.0.8
- builder 3.2.4
- erubi 1.12.0
- racc 1.7.3
- nokogiri 1.16.2 (x86_64-linux)
- rails-dom-testing 2.2.0
- crass 1.0.6
- loofah 2.22.0
- rails-html-sanitizer 1.6.0
- actionview 7.0.8
- rack 2.2.8
- rack-test 2.1.0
- actionpack 7.0.8
- nio4r 2.7.0
- websocket-extensions 0.1.5
- websocket-driver 0.7.6
- actioncable 7.0.8
- globalid 1.2.1
- activejob 7.0.8
- activemodel 7.0.8
- activerecord 7.0.8
- marcel 1.0.2
- mini_mime 1.1.5
- activestorage 7.0.8
- date 3.3.4
- timeout 0.4.1
- net-protocol 0.2.2
- net-imap 0.4.10
- net-pop 0.1.2
- net-smtp 0.4.0.1
- mail 2.8.1
- actionmailbox 7.0.8
- actionmailer 7.0.8
- actiontext 7.0.8
- public_suffix 5.0.4
- addressable 2.8.6
- ast 2.4.2
- base64 0.2.0
- bcrypt 3.1.20
- bindex 0.8.1
- msgpack 1.7.2
- bootsnap 1.18.3
- brakeman 6.1.2
- bundler 2.3.14
- matrix 0.4.2
- regexp_parser 2.9.0
- xpath 3.2.0
- capybara 3.40.0
- chartkick 5.0.6
- chronic 0.10.2
- database_cleaner-core 2.0.1
- database_cleaner-active_record 2.1.0
- database_cleaner 2.0.2
- stringio 3.1.0
- psych 5.1.2
- rdoc 6.6.2
- io-console 0.7.2
- reline 0.4.2
- irb 1.11.1
- debug 1.9.1
- orm_adapter 0.5.0
- method_source 1.0.0
- thor 1.3.0
- zeitwerk 2.6.12
- railties 7.0.8
- responders 3.1.1
- warden 1.2.9
- devise 4.9.3
- diff-lcs 1.5.1
- docile 1.4.0
- dotenv 3.0.2
- dotenv-rails 3.0.2
- factory_bot 6.4.6
- factory_bot_rails 6.4.3
- faker 3.2.3
- uri 0.13.0
- net-http 0.4.1
- faraday-net_http 3.1.0
- faraday 2.9.0
- ffi 1.16.3
- hashie 5.0.0
- mini_magick 4.12.0
- ruby-vips 2.2.1
- image_processing 1.12.2
- importmap-rails 2.0.1
- jbuilder 2.11.5
- json 2.7.1
- jwt 2.8.0
- language_server-protocol 3.17.0.3
- launchy 2.5.2
- multi_xml 0.6.0
- version_gem 1.1.3
- snaky_hash 2.0.1
- oauth2 2.0.9
- rack-protection 3.2.0
- omniauth 2.1.2
- omniauth-oauth2 1.8.0
- omniauth-google-oauth2 1.1.1
- omniauth-rails_csrf_protection 1.0.1
- parallel 1.24.0
- parser 3.3.0.5
- pg 1.5.4
- puma 5.6.8
- rails 7.0.8
- rails-controller-testing 1.0.5
- rainbow 3.1.1
- redcarpet 3.6.0
- rexml 3.2.6
- rspec-support 3.13.0
- rspec-core 3.13.0
- rspec-expectations 3.13.0
- rspec-mocks 3.13.0
- rspec-rails 6.1.1
- rubocop-ast 1.30.0
- ruby-progressbar 1.13.0
- unicode-display_width 2.5.0
- rubocop 1.60.2
- rubyzip 2.3.2
- sassc 2.4.0
- websocket 1.2.10
- selenium-webdriver 4.17.0
- simple_calendar 3.0.2
- simplecov-html 0.12.3
- simplecov_json_formatter 0.1.4
- simplecov 0.22.0
- sprockets 4.2.1
- sprockets-rails 3.4.2
- stimulus-rails 1.3.3
- turbo-rails 1.5.0
- web-console 4.2.1
- webdrivers 5.2.0
- whenever 1.0.0

**Tools**:
- GitHub https://github.com/CSCE431-Software-Engineering/turnover-m-c-a-b-s
- RuboCop 1.60.2
- SimpleCov 0.22.0
- Brakeman 6.1.2
- GitHub Actions
- Jira

## External Dependencies

- Docker: [Download the latest version](https://www.docker.com/products/docker-desktop)
- Heroku CLI: [Download the latest version](https://devcenter.heroku.com/articles/heroku-cli)
- Git: [Download the latest version](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- GitHub Desktop (optional): [Download here](https://desktop.github.com/)
  
## Installation
To set up the project locally, follow these steps:

```bash
# Clone the repository
git clone https://github.com/BACKED-Software/mabs.git
cd mabs

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate
```

## Usage
```bash
rails server
```

## Testing
```bash
bundle exec rspec
```

## Execute Code

Run in the terminal (if windows, powershell):
(for those running in WSL, add “sudo” in front of if permission denied)

docker pull paulinewade/csce431:latest 
Run docker image

Create a directory, for example `csce431`
mkdir mabs_tracker

Move to that directory
cd mabs_tracker

Mount and run the docker I
made for ubuntu:

(add “sudo” in front of if permission denied for all the following commands)

`docker run -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest`

**include the --rm option if you want the container (with database, if any) to be removed after the process has run.

`docker run --rm -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest`


### For windows replace $(pwd) -> ${PWD}.  See below:

`docker run -it --volume "${PWD}:/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest`


`docker run --rm -it --volume "${PWD}:/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest`


### Mac M1 Instructions

If you are using a Mac with M1 chip you need to use the following command instead:

`docker run -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 --platform linux/amd64 paulinewade/csce431:latest`

**include the --rm option if you want the container (with database, if any) to be removed after the process has run.

`docker run --rm -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 --platform linux/amd64 paulinewade/csce431:latest`


### Install the app

`bundle install && rails webpacker:install && rails db:create && db:migrate`


Run the app
`rails server --binding:0.0.0.0`

The application can be seen using a browser and navigating to http://localhost:3000/


## CI/CD

CI/CD has been implemented in the GitHub Actions in the repo here -> https://github.com/BACKED-Software/mabs/actions


## Contributors
 - Abdulhameed Adesokan
 - Dinesh Balakrishnan
 - Brandon Fornero
 - Kirk Graham
 - Conner Kaufhold

## Extra Help

Please contact Pauline Wade paulinewade@tamu.edu for any questions on the app.

## References
- https://www.atlassian.com/software/jira
- https://www.linkedin.com/learning/ruby-on-rails-7-essential-training
- Open AI (Github Copilot Extension)
- W3Schools
- https://tailwindcss.com/docs/
- https://getbootstrap.com/docs/5.0/

