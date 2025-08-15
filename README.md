# Device Registry App
A simple Ruby on Rails application that manages device assignments between users. In addition, the app includes a **basic authentication system**.

## Table of Contents
1. [Tech Stack](#tech-stack)  
2. [Setup](#setup)  
3. [Running the Application](#running-the-application)  
4. [Running Tests](#running-tests)  
5. [API Endpoints](#api-endpoints)  
6. [Product Logic Summary](#product-logic-summary)

## Tech Stack
- **Ruby**: 3.2.3 
- **Rails**: 7.1
- **Database**: Sqlite3
- **Authentication**: Simple session-based auth

## Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/tomasz-naklicki/device-registry.git
   cd device-assignment-app
   ```
2. **Install dependencies**
    ```bash
    bundle install
    ```
3. **Setup database**
    ```bash
    sudo apt install sqlite3
    bin/rails db:create
    bin/rails db:migrate
    rake db:test:prepare
    ```

## Running the Application

```bash
    rails server
```
The API endpoints are available at ```http://localhost:3000/api```.

## Running Tests 
```bash
    rspec spec
```

## API Endpoints

| Method | Endpoint       | Description               |
|--------|----------------|---------------------------|
| POST   | `/api/login`   | Authenticate user         |
| DELETE | `/api/logout`  | Log out current user      |
| POST   | `/api/signup`  | Create a new user         |
| POST   | `/api/assign`  | Assign device to a user   |
| POST   | `/api/unassign`| Return device from a user |
