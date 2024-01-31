# Task and Reminder Application

## About The Project

This application is designed to help users efficiently manage their daily tasks with reminder functionalities. Built with Flutter and Firebase, it offers a seamless user experience and real-time integration with a cloud database.

## Features

- <b>User Authentication:</b> Sign up, log in, and log out.
- <b>Task Management:</b> Add, view, edit, and delete tasks.
- <b>Reminders:</b> Set up reminders for upcoming tasks.
- <b>Data Synchronization:</b> User data is synchronized in real-time with Firebase.

## Getting Started

To get a local copy up and running, follow these simple steps.

## Prerequisites

- Finish the [Roadmap](https://roadmap.sh/flutter)
- Flutter (Latest Version)
- Dart SDK
- A Firebase account

## Installation

1. **Fork the Repository**:
   - Visit `https://github.com/DevXpressInc/flutter-intern-practice`.
   - Click the "Fork" button to create a copy under your GitHub account.

2. **Clone Your Fork**:
```bash
git clone https://github.com/[YourUsername]/Flutter-intern-practice.git
```

3. Navigate to the project directory:

```bash
cd Flutter-intern-pratice
```

4. Install all dependencies:

```bash
cd flutter pub get
```

5. Set up your Firebase project and download the google-services.json file (for Android) or GoogleService-Info.plist (for iOS).

6. Run the application:

```bash
flutter run
```

# Working with the Project

- Do Not Push Directly to Main Repository: Make changes in your fork and create pull requests for any updates.
- Stay Updated: Regularly fetch and merge changes from the main repository to your fork:

```bash
git remote add upstream https://github.com/[YourUsername]/Flutter-intern-practice.git
git fetch upstream
git merge upstream/main
```

- Create Feature Branches: For new features or changes, create separate branches in your fork:

```bash
git checkout -b feature/YourFeatureName
```

- Push to Your Fork: Commit your changes and push them to your forked repository.
- Create Pull Requests: For merging your changes into the main repository, create a pull request from your fork.

# Requirement

## Application Overview
- Name: Task and Reminder Application
- Platform: Mobile (iOS or Android)
- Technologies: Flutter for front-end, Firebase for back-end

## Pages and Key Features

### 1.  Splash Screen (Optional)
- Display the application logo.
- Transition to either the Home Screen or Authentication Screen, depending on the user's login status.

### 2. Authentication Screen

- Features:
    - Email and password-based registration.
    - Email and password-based login.
    - Password reset option.
- Firebase Integration: Use Firebase Authentication.

### 3. Home/Dashboard Screen
- Features:
    - Display a list of tasks.
    - Options to view, edit, or delete existing tasks.
    - Button to add a new task.
- Firebase Integration: Retrieve tasks from Firestore.

### 4. Task Creation/Editing Screen
- Features:
    - Form to enter/edit task details (title, description, due date, priority).
    - Option to set a reminder.
- Firebase Integration: Add or update tasks in Firestore.

### 5. Reminder Setup Screen

- Features:
    - Select date and time for the reminder.
    - Option to repeat the reminder (e.g., daily, weekly).
- Local Notifications: Implement local notifications for reminders.

### 6. Profile Screen
- Features:
    - Display user information.
    - Option to log out.
- Firebase Integration: Manage user session.

### 7. Settings Screen (Optional)
- Features:
    - Theme selection (light/dark mode).
    - Language selection.
    - Notification settings.

## Additional Requirements

### Data Management

- Use Firestore to store and manage tasks and user data.
- Implement real-time data synchronization. (No worries, it's in real time by default ;)

### User Interface
- Follow Material Design (for Android) or Cupertino Design (for iOS) principles. (Choose one)
- Ensure responsive and intuitive UI/UX.

### Testing
- Write unit tests for business logic.
- Perform integration testing for Firebase services.

### Documentation(BONUS)
- Document the codebase.
- Create a README file for GitHub repository.

### Version Control
- Use Git for version control.
- Regular commits and descriptive commit messages.

### Bonus Features (if time permits)
- Implement task categorization or tagging.
- Add a calendar view for tasks.
- Social media sharing capabilities.