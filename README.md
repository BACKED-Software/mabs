
# MCABS App Tracker README

This README provides the necessary steps to set up and run the MCABS (Medical Cannabis Access Barrier Solutions) App Tracker, a Ruby on Rails application. The application is designed to track and manage patient access to medical cannabis, ensuring efficient monitoring and support.

## Ruby Version

Ensure you have Ruby 3.3.0 installed on your system. You can check your Ruby version by running:

```bash
ruby -v
```

If you do not have the correct version, you can install Ruby 3.3.0 using a Ruby version manager like `rbenv` or `rvm`.

## System Dependencies

Before setting up the MCABS App Tracker, you need to install several system dependencies:

- Ruby 3.3.0
- Rails 7
- A database system (e.g., PostgreSQL, MySQL, SQLite)
- Node.js (for Webpacker)
- Yarn (for managing JavaScript packages)

## Configuration

1. Clone the repository:

```bash
git clone <repository-url>
cd <repository-name>
```

2. Install the required Ruby gems:

```bash
bundle install
```

3. Install JavaScript packages:

```bash
yarn install
```

## Database Creation and Initialization

Assuming you're using PostgreSQL:

1. Create the database:

```bash
rails db:create
```

2. Migrate the database schema:

```bash
rails db:migrate
```

3. Seed the database (if you have a seeds file):

```bash
rails db:seed
```

## How to Run the Test Suite

To ensure the integrity of your application, run the test suite:

```bash
rails test
```

Or, if you are using RSpec:

```bash
rspec
```

## Services

If your application uses services like job queues, cache servers, or search engines, document how to set up and use these services here.

## Deployment Instructions

1. Ensure all your changes are committed and pushed to the repository.
2. Follow the deployment instructions specific to your hosting provider (Heroku). Ideally this should auto deploy for all non feature branches.
3. Add any new environment variables and add-on services (like database, email services) as required by your application.

## Additional Notes

- Always check the `Gemfile` for any additional gems you might need to install.
- For more detailed information on Rails deployment, consult the [Rails Guides](https://guides.rubyonrails.org/).

With this README, your team members or contributors should have a clear understanding of how to get the MCABS App Tracker up and running.
```
This markdown content is ready to be added to your README.md file for the MCABS App Tracker Ruby on Rails application.
