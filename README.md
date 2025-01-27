# craft_silicon

# Flutter Project Setup Guide

This guide explains how to set up and run the Flutter project after cloning it from the repository.

---

## Prerequisites

Before you start, ensure you have the following tools installed on your machine:

- **[Flutter SDK](https://flutter.dev/docs/get-started/install)** (version 3.0 or higher recommended)
- **Dart SDK** (comes with Flutter)
- **Git** (for cloning the repository)
- **Android Studio** or **Xcode** (for emulators and building native apps)
- An IDE such as **[VS Code](https://code.visualstudio.com/)** or **[Android Studio](https://developer.android.com/studio)**

---

## Installation Steps

 1. Clone the Repository

Open your terminal or command prompt and run the following command:

```bash
git@github.com:m-k-gichohi/craft_silicon_weather_app.git
```

2. Then proceed to open the folder with your favorite IDE

    After having the project open 


 3. Copy the  ```env.example``` file to ```env```   file inside the root folder of the project.

4. Add ypur api key to the env file.

5. After adding the key you need now to run the following command

```bash 
flutter pub get
```

5. Then run the following command  to generate the required files


```bash
dart run build_runner build
```

6. Once you are done building the files,
Run
```bash 
flutter run
```

