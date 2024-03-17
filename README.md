## .Introduction: A brief overview of the project, its purpose, and key features.
### Overview
This is a web app API for sharing YouTube videos using Ruby on Rails with PostgreSQL and Redis, all running in Docker
### Features

1. User registration and login
2. Sharing YouTube videos
3. Viewing a list of shared videos (no need to display up/down votes)
4. Real-time notifications for new video shares: When a user shares a new video, other logged-in users should receive a real-time notification about the newly shared video.

### Prerequisites:
Please ensure you are using Docker Compose V2. This project relies on the `docker compose` command, not the previous `docker-compose` standalone program.

https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

Check your docker compose version with:
```
% docker compose version
Docker Compose version v2.24.6-desktop.1
```
### Installation & Configuration:
- Cloning the repository
  ```
  git clone git@github.com:lamhh26/funny_videos_be.git

  # Or

  git clone https://github.com/lamhh26/funny_videos_be.git
  ```
- Configuring settings and installing
   ```
    cp .env.example .env
    docker compose build
   ```
### Database Setup
```
docker compose run --rm web rails db:setup

```

### Running the Application
- Running the development server
  ```
  docker compose up -d
  ```
  After that you can see the app at http://localhost:3000

### Running tests
- With test suites of `models`, `requests`, `sidekiq`, we can run as below
  ```
  docker compose run --rm web rspec --exclude-pattern "spec/system/**/*_spec.rb"
  ```
- With test suites of the intergration test in `system` folder: In integration testing we will use the libraries `capybara` and `selenium-webdriver`
   - Fist running backend app like [above]([https://github.com/lamhh26/funny_videos_be/edit/main/README.md#running-the-application)
   - First we need to run the frontend application. At [frontend repo](https://github.com/lamhh26/funny_videos_be) run these commands
     ```
     # Create .env file if it doesn't exist
     cp .env.example .env

     # Change the file content to the following
     REACT_APP_API_BASE_URL=http://web:3000
     REACT_APP_WEBSOCKET_URL=ws://web:3000/cable

     # Build a image from Dockerfile
     docker build -f Dockerfile.dev -t funny-videos-fe .
     
     # Run the frontend app
     
     ```
