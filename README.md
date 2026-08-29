# SmartStock - Inventory & Reorder Management System (India Edition) 🇮🇳

[![Flutter](https://img.shields.io/badge/Flutter-3.3+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-v24.5.0-339933?logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Currency](https://img.shields.io/badge/Currency-INR%20(%E2%82%B9)-0088CC)](#)
[![Taxation](https://img.shields.io/badge/Taxation-18%25%20GST-FF9933)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](#)

**SmartStock** is an intelligent, full-featured Inventory and Smart Reorder Management System tailored for retail, wholesale, and multi-channel businesses in India. It empowers store owners, managers, and staff to maintain optimal inventory health, automate purchase orders before stockouts occur, process point-of-sale transactions with UPI/GST compliance, and track real-time revenue analytics.

---

## 🌟 Key Features

### 🔐 1. Multi-Role Authentication & Access Control
* **Administrator**: Full access to system configuration, inventory CRUD, supplier management, analytics, user management, and purchase order approvals.
* **Inventory Manager**: Access to stock levels, reorder engine, purchase order issuance, and supplier directories.
* **Store Staff**: Streamlined interface for quick stock verification, stock counting, and POS checkout.

### 📊 2. Real-Time Dashboard & Analytics
* **Metric Cards**: Total Products, Total Stock Value (in ₹ INR), Low Stock Alerts, and Critical Shortages.
* **Sales Revenue Trend Chart**: Interactive 7-day revenue performance visualizer (Chart.js).
* **Stock Levels by Category**: Visual distribution bar chart showing stock volume across categories.
* **Live Activity Feed**: Audit trail tracking sales, purchase order issuances, and stock receptions in real-time.

### 📦 3. Inventory Management
* **Complete CRUD**: Add, edit, view, and delete products with SKU, Barcode, Category, Purchase Price (₹), Selling Price (₹), Min Stock, and Max Stock thresholds.
* **Stock Health Badges**:
  * 🟢 **In Stock**: Healthy quantity above minimum stock threshold.
  * 🟡 **Low Stock**: Quantity at or below safety threshold.
  * 🔴 **Out of Stock**: Zero units available.

### 🔄 4. Smart Reorder Engine
Automated Reorder Point (ROP) algorithm:
$$\text{Reorder Point (ROP)} = (\text{Average Daily Sales} \times \text{Lead Time Days}) + \text{Safety Stock}$$

* **Urgency Categorization**:
  * **Critical**: Items out of stock or under minimum threshold.
  * **Soon**: Items approaching reorder point within lead time.
  * **Normal**: Healthy stock levels.
* **Automated Suggested Order Quantities**: Calculates $\text{Maximum Stock} - \text{Current Stock}$ to prevent overstocking or stockouts.

### 🚛 5. Purchase Order (PO) Workflow & Automated Stock Receipts
* Create Purchase Orders for suppliers (*Apex Tech Supplies Bengaluru*, *Global Logistics India Mumbai*, *Prime Office Supplies Delhi*).
* Multi-line item configuration with automatic total cost calculations in ₹ INR.
* **1-Click Mark Received**: Receiving a PO automatically adds stock quantities directly into product inventory records.

### 🛒 6. Point of Sale (POS) & UPI Payment Integration
* Quick item lookup and tap-to-add cart system.
* **GST Compliance**: Automated **18% GST** calculation on subtotal amounts.
* **Multi-Payment Support**: Cash, **UPI** (GPay, PhonePe, Paytm), and Card options.
* Instant stock deduction upon checkout.

### 🌙 7. Dark & Light Theme System
* Built-in dark mode / light mode toggle.
* Custom palette featuring Navy `#2563eb`, Emerald `#059669`, Amber `#d97706`, and Slate `#0f172a`.

---

## 🛠️ Technology Stack

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Flutter Application** | Dart / Flutter 3.3+ | Mobile & Desktop cross-platform application UI |
| **State Management** | Flutter Riverpod | Reactive state management & provider architecture |
| **Routing** | GoRouter | Declarative routing & role-based navigation |
| **Web Interface** | HTML5, CSS3, JavaScript (ES6+) | Standalone web preview interface |
| **Data Visualization** | Chart.js | Interactive revenue and category charts |
| **HTTP Server** | Node.js (v24.5.0) | Lightweight local development web server |

---

## 📁 Directory Structure

```
SmartStock/
├── lib/
│   ├── core/
│   │   ├── constants/       # AppConstants, currency symbols (₹), role permissions
│   │   ├── network/         # API Client (Dio)
│   │   └── theme/           # AppColors, AppTheme, Typography, Spacing
│   ├── features/
│   │   ├── auth/            # Login, Register, Forgot Password screens & providers
│   │   ├── dashboard/       # Admin, Manager, Staff dashboard screens & providers
│   │   ├── inventory/       # Product list, Add/Edit modal, Product detail
│   │   ├── purchases/       # Purchase order creation, PO detail, Receive stock
│   │   ├── reorder/         # Smart reorder engine, settings & analytics
│   │   ├── sales/           # POS terminal screen & sale processing
│   │   └── suppliers/       # Supplier directory & contact management
│   ├── shared/
│   │   ├── models/          # Product, PO, Supplier, User, Reorder data models
│   │   └── widgets/         # Custom UI buttons, cards, dialogs, inputs, charts
│   └── main.dart            # Flutter application entry point
├── app.js                   # Web application logic, state manager & INR currency logic
├── index.html               # Responsive web application interface
├── styles.css               # Modern UI design system with dark/light themes
├── server.js                # Node.js HTTP server
├── pubspec.yaml             # Flutter dependencies & assets config
├── README.md                # Project documentation
└── .gitignore               # Git ignore rules
```

---

## 🚀 How to Run the Project

### Option A: Run Web Application Preview (Instant Browser Access)

1. Ensure [Node.js](https://nodejs.org) is installed.
2. Start the local web server:
   ```bash
   node server.js
   ```
3. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

---

### Option B: Run Flutter Application

1. Ensure [Flutter SDK](https://docs.flutter.dev/get-started/install) is installed and added to your system PATH.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation (for Riverpod & Freezed models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Launch the application:
   ```bash
   # Run on Chrome
   flutter run -d chrome

   # Run on Windows Desktop
   flutter run -d windows
   ```

---

## 🔑 Pre-Configured Demo Credentials

Use any of the following pre-seeded credentials on the login screen:

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@smartstock.com` | `admin123` | Full Access (All Screens & System Settings) |
| **Inventory Manager** | `manager@smartstock.com` | `manager123` | Stock Management, Reorders, POs & Suppliers |
| **Store Staff** | `staff@smartstock.com` | `staff123` | Stock Verification & Sales POS Terminal |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Balachandransakthivel/SmartStock/issues).

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).

Developed with ❤️ by **[Balachandran S](https://github.com/Balachandransakthivel)**.
