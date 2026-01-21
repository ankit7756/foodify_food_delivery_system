# 🍔 FOODIFY – Food Delivery System

Foodify is a mobile food delivery application built using **Flutter** with **Clean Architecture** principles.  
The app supports **user authentication**, **session management**, and **API-based login & signup** using a **Node.js + MongoDB backend**.

This project was developed as part of multiple academic sprints, focusing on progressive feature implementation.

---

## 📱 Application Overview

Foodify allows users to:
- Register a new account
- Login securely using API authentication
- Persist login sessions across app restarts
- Access a dashboard after successful authentication
- Experience a clean and structured Flutter project architecture

---

## 🏗️ Architecture Used

The project follows **Clean Architecture**, separating responsibilities into:

- **Presentation Layer** – UI (screens, widgets)
- **Domain Layer** – Business logic (entities, repositories, use cases)
- **Data Layer** – Data handling (local storage, API calls)

This structure improves **scalability**, **maintainability**, and **testability**.

---

## 🚀 Implemented Features

### Local Authentication
- Signup and Login using **Hive (local database)**
- Clean Architecture folder structure
- Splash Screen & Onboarding Flow
- Local user validation
- Dashboard navigation after login

### API Authentication
- Signup and Login using **REST API**
- Backend built with **Node.js + Express**
- **MongoDB** used for persistent storage
- **JWT Token Authentication**
- API integration in Flutter
- Session persistence using **Shared Preferences**
- Auto-login (session restore on app relaunch)

---

## 🛠️ Technologies Used

### Frontend (Flutter)
- Flutter (Dart)
- Hive (Local database)
- Shared Preferences (Session storage)
- HTTP package (API integration)
- Clean Architecture

### Backend (API)
- Node.js
- Express.js
- MongoDB (Mongoose)
- JSON Web Tokens (JWT)
- bcrypt (Password hashing)
- Postman (API testing)

---


