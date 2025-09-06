#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Install Node.js dependencies
npm install

# Build Tailwind CSS
npm run build:css

# Precompile assets
bundle exec rails assets:precompile

# Migrate database
bundle exec rails db:create
bundle exec rails db:migrate

# Run seeds if needed (optional - remove if you don't want to seed in production)
bundle exec rails db:seed