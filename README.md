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
  - Copy the `.env.example` file to a new file called `.env`
   ```
    cp .env.example .env
    docker compose build
   ```
  - 

