# 🐝 User Hive – Flutter Assessment App

A Flutter app built as part of an internship assessment, showcasing clean architecture using BLoC, API integration, infinite scroll, search, and dynamic UI. The app fetches users, posts, and todos from the [DummyJSON API](https://dummyjson.com) and supports light/dark theme and local post creation.

---

## 📱 Features

✅ Fetch users from API with pagination  
✅ Infinite scroll and real-time search  
✅ Detailed user view with posts and todos  
✅ Locally add posts (offline-only)  
✅ Pull-to-refresh on user list  
✅ Light/Dark mode toggle  
✅ Clean code using `flutter_bloc` and proper folder structure

---

## 🛠️ Tech Stack

- **Flutter** 🐦
- **BLoC** for state management
- **http** for API requests
- **Equatable** for cleaner BLoC logic
- **MultiBlocProvider** and custom Cubits

---

## 📂 Project Structure (Clean Architecture)

```
lib/
├── blocs/              # BLoC, events, and states
├── cubit/              # ThemeCubit
├── models/             # Data models (User, Post, Todo)
├── repositories/       # API services
├── screens/            # UI screens
├── widgets/            # Reusable UI components
└── main.dart           # App entry point
```

---

## 🔌 API Used

- `GET https://dummyjson.com/users` – User list  
- `GET https://dummyjson.com/posts/user/{userId}` – Posts for a user  
- `GET https://dummyjson.com/todos/user/{userId}` – Todos for a user  

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/user-hive.git
cd user-hive
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

> Make sure your emulator or device has internet access.

---

## ⚙️ Customization

- Add `shared_preferences` or Hive to persist theme/posts (optional)
- Add authentication for real-user context (advanced)
- Replace DummyJSON with a real backend in production

---

## 🙌 Author

👨‍💻 **Yash Chandra**  
[LinkedIn](https://www.linkedin.com/in/yash-chandra-b27748262/) | [GitHub](https://github.com/WhyC03)

---