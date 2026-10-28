# PIN Authentication Module

A modular, localized, and responsive PIN authentication feature built for the iOS app using **SwiftUI** and clean Model, View, and ViewModel (MVVM) architectural patterns.

---

## 🌟 Key Features

* **Secure PIN Entry**: Dynamic length verification, tactile error feedback (shake animations) with haptic (vibration), and secure state handling.
* **Modular Architecture**: Decoupled using **Feature-first** in combination with **MVVM** design separating core design systems from business logic.
* **Multi-Language Support**: Fully localized in **Khmer**, **Lao**, **Chinese**, and **English** using System Locale Matching meaning the feature dynamically changes its language base on the phone's system language preference.
* **Foldable & Responsive Layout**: Validated against multi-device viewports including **iPhone Duo**, **iPhone 18 Pro Max**, **iPhone 11 Pro**, and **iPhone SE**.
* **Clean State Transitions**: Smooth, flicker-free UI rendering powered by SwiftUI `withAnimation` transitions and fading in and out animation upon appearing and disappearing of the PinScreenView.

---

## 📁 Repository Structure

The project follows a clean, modular structure:

```text
Pin Feature/
├── Module-Core/
│   ├── DesignSystem/
│   │   ├── Resource/
│   │   │   ├── CustomFont/          # NotoSans, Nunito, Phetsarath
│   │   │   ├── Assets
│   │   │   └── Localizable
│   │   └── Theme/
│   │       └── AppFont
│   └── Utility/
│       ├── Device/
│       │   └── DuoSupport
│       └── Extension/
│           └── Color + Extension
├── Module-Feature/
│   ├── Feature-Home/
│   │   ├── View/Screen/
│   │   │   └── HomeScreenView
│   │   └── ViewModel/
│   │       └── HomeScreenViewModel
│   └── Feature-Pin/
│       ├── Helper/
│       │   ├── PinScreenMetricsHelper
│       │   └── PinScreenSizedHelper
│       ├── Model/
│       │   └── PinScreenModel
│       ├── View/Screen/
│       │   └── PinScreenView
│       └── ViewModel/
│           └── PinScreenViewModel
└── Module-Main/
    └── View/Screen/
        └── Pin_FeatureApp
