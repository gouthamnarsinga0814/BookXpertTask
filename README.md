# 

# BookXpertTask - Firebase Auth, PDF Viewer, Core Data, Image Handling & Push Notifications

An iOS application built using Swift that demonstrates core functionalities such as Firebase Authentication, PDF viewing, image capture and gallery selection, offline data management using Core Data, and push notifications via FCM.

# 🚀 Features

# 1. 🔐 User Authentication
Integrated Google Sign-In using Firebase Authentication.
User information is securely stored in Core Data for offline access.
# 2. 📄 PDF Viewer - Report
Displays a remote PDF report from:
https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf
Utilizes native PDFKit or third-party libraries (e.g., PDFView) to render PDF within the app.
# 3. 📷 Image Capture & Gallery Selection
Option to capture an image using the device's camera.
Option to pick an image from the gallery.
Selected image is displayed within the app.
# 4. 🗃️ Core Data with API Integration
Fetches data from: https://api.restful-api.dev/objects
Stores and manages data using Core Data:
Create
Read
Update
Delete
Includes:
Error handling
Validations
# 5. 🔔 Push Notifications (FCM)
Sends a real-time push notification when an item is deleted.
Notification includes details of the deleted item.
Option to enable/disable notifications via app settings.
# 🛠️ Technical Stack

| Feature             | Description                              |
|---------------------|------------------------------------------|
| Language            | Swift                                    |
| Architecture        | MVVM                                     |
| Authentication      | Google Sign-In using Firebase            |
| Offline Storage     | Core Data                                |
| PDF Viewer          | PDFKit          |
| Image Handling      | Camera + Gallery (UIImagePicker)         |
| Push Notifications  | Firebase Cloud Messaging (FCM)           |
| Light/Dark Mode     | Supported                                |
| Runtime Permissions | Camera, Gallery, Notifications           |

# 📱 UI Highlights

Clean and modern UI/UX
Responsive layout with support for light and dark mode
Handles all runtime permissions (camera, gallery, notifications)
# 🧱 Architecture

The app follows the MVVM (Model-View-ViewModel) architecture ensuring a clean separation of concerns and better testability.

# 🧪 Validation & Error Handling

Input validations for user-generated content
Graceful error handling for API failures, permissions, and data operations
# 📦 Installation

<pre> ```bash # Swift Package Manager Installation Guide 1. Open your Xcode project. 2. Navigate to: File > Add Packages... 3. Enter the package repository URL: https://github.com/google/GoogleSignIn-iOS and https://github.com/firebase/firebase-ios-sdk.git 4. Choose the version you want to install (Up to Next Major or Exact). 5. Click “Add Package” 5. Set up Firebase and configure your GoogleService-Info.plist 6.Build and run on a real device or simulator.  # That’s it! The package will be available in your project. ``` </pre>


# 📄 License

This project is open source and available under the MIT License.
