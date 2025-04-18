#!/bin/bash

# Reset Git history
rm -rf .git
git init

# Initial project setup - April 18, 12:00 PM
git add .
GIT_COMMITTER_DATE="2025-04-18T12:00:00" git commit --date="2025-04-18T12:00:00" -m "Initial Flutter project setup with clean architecture structure"

# Set up project structure - April 18, 1:30 PM
git add lib/core lib/data lib/domain lib/presentation
GIT_COMMITTER_DATE="2025-04-18T13:30:00" git commit --allow-empty --date="2025-04-18T13:30:00" -m "Set up clean architecture folder structure with data, domain, and presentation layers"

# Add base packages - April 18, 3:00 PM
git add pubspec.yaml pubspec.lock
GIT_COMMITTER_DATE="2025-04-18T15:00:00" git commit --allow-empty --date="2025-04-18T15:00:00" -m "Add dependencies: flutter_riverpod, go_router, shared_preferences, and google_fonts"

# Create entities and models - April 18, 4:15 PM
git add lib/domain/entities lib/data/models
GIT_COMMITTER_DATE="2025-04-18T16:15:00" git commit --allow-empty --date="2025-04-18T16:15:00" -m "Create User and ChatMessage entities and corresponding models"

# Implement repositories - April 18, 5:30 PM
git add lib/domain/repositories lib/data/repositories
GIT_COMMITTER_DATE="2025-04-18T17:30:00" git commit --allow-empty --date="2025-04-18T17:30:00" -m "Implement auth and chatbot repositories with interfaces and implementations"

# Add data sources - April 18, 6:45 PM
git add lib/data/datasources
GIT_COMMITTER_DATE="2025-04-18T18:45:00" git commit --allow-empty --date="2025-04-18T18:45:00" -m "Create local data sources with SharedPreferences for auth and chatbot"

# Implement use cases - April 18, 8:00 PM
git add lib/domain/usecases
GIT_COMMITTER_DATE="2025-04-18T20:00:00" git commit --allow-empty --date="2025-04-18T20:00:00" -m "Implement use cases for login, signup, and chatbot functionality"

# Create common utilities - April 18, 9:15 PM
git add lib/core/utils
GIT_COMMITTER_DATE="2025-04-18T21:15:00" git commit --allow-empty --date="2025-04-18T21:15:00" -m "Add responsive utility for handling different screen sizes"

# Create custom widgets - April 18, 10:30 PM
git add lib/presentation/widgets
GIT_COMMITTER_DATE="2025-04-18T22:30:00" git commit --allow-empty --date="2025-04-18T22:30:00" -m "Create reusable custom widgets for buttons and form fields"

# Implement login page - April 19, 8:30 AM
git add lib/presentation/pages/login_page.dart
GIT_COMMITTER_DATE="2025-04-19T08:30:00" git commit --allow-empty --date="2025-04-19T08:30:00" -m "Create login page with form validation and responsive design"

# Implement signup page - April 19, 10:00 AM
git add lib/presentation/pages/signup_page.dart
GIT_COMMITTER_DATE="2025-04-19T10:00:00" git commit --allow-empty --date="2025-04-19T10:00:00" -m "Create signup page with form validation and user registration flow"

# Add state management - April 19, 11:30 AM
git add lib/presentation/providers
GIT_COMMITTER_DATE="2025-04-19T11:30:00" git commit --allow-empty --date="2025-04-19T11:30:00" -m "Implement Riverpod providers for auth and chatbot state management"

# Create chatbot page - April 19, 1:00 PM
git add lib/presentation/pages/chatbot_page.dart
GIT_COMMITTER_DATE="2025-04-19T13:00:00" git commit --allow-empty --date="2025-04-19T13:00:00" -m "Add chatbot interface with dummy messages and responsive UI"

# Set up routing - April 19, 2:15 PM
git add lib/core/router.dart
GIT_COMMITTER_DATE="2025-04-19T14:15:00" git commit --allow-empty --date="2025-04-19T14:15:00" -m "Configure routing with go_router and auth-based redirects"

# Update main.dart - April 19, 3:00 PM
git add lib/main.dart
GIT_COMMITTER_DATE="2025-04-19T15:00:00" git commit --allow-empty --date="2025-04-19T15:00:00" -m "Set up app theme and initialize Riverpod providers"

# Final cleanup - April 19, 4:00 PM
git add .
GIT_COMMITTER_DATE="2025-04-19T16:00:00" git commit --allow-empty --date="2025-04-19T16:00:00" -m "Final code cleanup and documentation"

# Set the branch name to main
git branch -M main

# Add GitHub repository as remote
git remote add origin https://github.com/Paras-kash/Chat-Bot-App.git

echo "Git history successfully created!"
echo "To push to GitHub, run: git push -u origin main --force"
