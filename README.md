# Koll - Restaurant & Delivery App

A cross-platform Flutter application for "Koll", a restaurant and delivery service. This app supports Android, iOS, and Web.

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0 or later)
*   [Git](https://git-scm.com/)
*   [Firebase CLI](https://firebase.google.com/docs/cli) (for configuring Firebase)

### 🔒 Security Check

This repository **does not** contain sensitive configuration files (like `google-services.json` or `firebase_options.dart`). You must generate these for your own environment.

### 🛠️ Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/HosamRaouf/koll.git
    cd koll
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase:**
    Since the Firebase configuration files are ignored for security, you need to re-connect the app to your Firebase project.

    Run the following command and select your project (`koll-8ca48`):
    ```bash
    flutterfire configure
    ```
    *This command will generate the secure `firebase_options.dart` and `google-services.json` files for you locally.*

4.  **Run the App:**
    ```bash
    flutter run
    ```

## 📦 Deployment (Web)

To deploy the web version to GitHub Pages, run the included deployment script:

```bash
bash deploy.sh
```

## 📱 App Features
- **User App**: Browse menus, place orders, track delivery.
- **Restaurant Dashboard**: Manage orders, update menu, view statistics.
- **Driver App**: Accept orders, navigation, delivery confirmation.

## 📄 License
This project is proprietary.
