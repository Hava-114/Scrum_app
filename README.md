# 🚀 Scrum Status App

  A lightweight Scrum tracking application built using Flutter and Firebase to manage daily task updates efficiently with a clean and responsive UI.

##📱 Overview

  The Scrum Status App enables users to add daily updates, track task progress, and monitor productivity in a simple and structured manner.

---

## ⚙️ Tech Stack

    Frontend: Flutter (Dart)
    Backend: Firebase Firestore
    Authentication: Firebase Authentication
    State Management: Provider

---

## 🔥 Efficient Use of Flutter

  Flutter is used to create a fast, responsive, and scalable user interface.
  
  Single codebase for cross-platform development
  
  Hot reload for rapid UI development
  
  Reusable widgets for maintainability
  
  Provider for efficient state management
  
  Clean separation of UI and business logic

---

## ☁️ Efficient Use of Firebase

Firebase acts as a scalable and real-time backend for the application.

### 📦 Firestore Database

  Data is stored in a structured format using a document-per-user approach:

      tasks (collection)
        └── userEmail (document)
              ├── username
              ├── email
              ├── photoUrl
              └── tasks (array of task objects)

---

## ⚡ Advantages

  Fast read and write operations
  
  Real-time data synchronization (extendable)
  
  Scalable for multiple users
  
  Secure with authentication

---

## 🔐 Authentication

  Firebase Authentication is used to manage user identity securely.
  
  Stores user name, email, and profile photo
  
  Ensures user-specific data isolation

---

## 🧠 Architecture (MVVM)

  The application follows the Model-View-ViewModel pattern.
      
      lib/
      ├── model/        → Data models
      ├── view/         → UI screens
      ├── view_model/   → Business logic & state

---

## Benefits

  Clean and organized code
  
  Easy to maintain and scale
  
  Separation of concerns

---

## ✨ Key Features

  Add and manage daily tasks
  
  Track task status (Hold / Processing / Completed)
  
  Happiness rating system
  
  User-wise task grouping
  
  Expandable dropdown task view
  
  Secure data handling

---

## 🚀 Future Enhancements

  Real-time updates using StreamBuilder
  
  Task editing and deletion
  
  Push notifications
  
  WhatsApp integration for reports
  
  Admin dashboard

---

## 📌 Conclusion

  This project demonstrates how Flutter and Firebase can be efficiently combined to build a scalable, real-time application with minimal backend complexity, making it ideal for rapid development.
