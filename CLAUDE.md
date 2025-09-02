# Development Guidelines for GAZE

## Project Overview
GAZE is a Code Snippet Manager - a production Rails application for engineers and developers to save, organize, and share code snippets effectively.

## Rails 7.2 Best Practices

### Code Quality
- Follow Rails conventions and idioms
- Use strong parameters for all controller actions
- Implement proper error handling with rescue_from
- Use ActiveRecord validations and callbacks appropriately
- Keep controllers thin, models fat
- Use concerns for shared functionality
- Write descriptive method and variable names

### Security
- Always use strong parameters in controllers
- Sanitize user input properly
- Use Rails' built-in CSRF protection
- Implement proper authorization checks
- Never expose sensitive data in logs or error messages
- Use Rails' encrypted credentials for secrets

### Performance
- Use database indexes appropriately
- Implement eager loading to avoid N+1 queries
- Use Rails caching where beneficial
- Optimize database queries with includes/joins
- Use pagination for large datasets

### Testing
- Write comprehensive tests using Rails testing framework
- Use fixtures or factories for test data
- Test both happy path and edge cases
- Write system tests for critical user flows

### Frontend (Hotwire)
- Use Turbo for SPA-like behavior
- Implement Stimulus controllers for JavaScript interactions
- Follow Rails' convention over configuration for views
- Use partials to keep views DRY

## Development Instructions

### Setup
```bash
bundle install
yarn install
rails db:create db:migrate
```

### Running the Application
```bash
./bin/dev
```

### Testing
```bash
rails test
rails test:system
```

### Code Quality Checks
```bash
rubocop
brakeman
```

## Git Commit Guidelines

**IMPORTANT**: When creating commits, use only:
```bash
git commit
```

Do NOT use `git commit --author` or any author flags. Let git use the default author configuration.

## Code Standards

### What NOT to Do
- Do not write speculative or unused code
- Do not create overly complex abstractions without clear need
- Do not ignore Rails conventions without good reason
- Do not commit code that creates technical debt
- Do not use deprecated Rails methods or patterns
- Do not write code without tests for critical functionality

### File Organization
- Keep related functionality together
- Use Rails' conventional directory structure  
- Create custom classes in `app/lib/` for domain logic
- Use `app/services/` for complex business operations

### Database Design
- Use Rails migrations for all schema changes
- Add appropriate database constraints
- Use foreign keys where relationships exist
- Create indexes for commonly queried columns

## Deployment Considerations
- Use environment variables for configuration
- Set up proper logging
- Configure caching appropriately for production
- Use Rails' asset pipeline correctly
- Implement health check endpoints

This application should demonstrate production-ready Rails development practices while solving a real problem for the developer community.