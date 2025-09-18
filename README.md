# ☕ Ahwa Store Manager App

A Flutter-based **Smart Ahwa Manager** app designed for coffee store.
It helps streamline operations by managing customer orders, tracking top-selling drinks, and generating daily sales reports.

---

## ✨ Features

- ➕ **Add Orders** with customer name, drink type, and special instructions.
- ✅ **Mark Orders as Completed** once served.
- 📋 **View Orders Dashboard** with pending/completed orders.
- 📊 **Sales Reports** showing:
  - Top-selling drink.
  - Total customers.
  - Total orders served.
- 🗄️ **SQLite Database** for offline local storage.
- 🎨 Modern & user-friendly UI with animations.

---
## ✨ UI
<img src="https://github.com/user-attachments/assets/5b8b16ed-3df4-4598-84c9-150bd603df6e" width="300" />
<img src="https://github.com/user-attachments/assets/348b959f-efba-44a7-a788-d3ebd36d22a0" width="300" />
<img src="https://github.com/user-attachments/assets/15957094-c599-4a58-ac08-7545da06faaa" width="300" />



---

## 🏛️ Architecture

The app follows **SOLID principles** and **OOP concepts**:

- **S**ingle Responsibility → Each class handles one clear responsibility (e.g., `OrderService`, `ReportService`).  
- **O**pen/Closed → Services are abstracted with interfaces, so you can extend without modifying core logic.  
- **L**iskov Substitution → Interfaces and abstract classes ensure interchangeable implementations.  
- **Encapsulation** → Models (`Order`, `Drink`) hide internal details with clear APIs.  
- **Dependency Injection** → Using `get_it` for clean service management.

---

## 📂 File Structure

```bash
lib/
├── core/
│   ├── models/              # Data models (Order, Drink, Report)
│   └── services/            # Abstract service interfaces
│
├── features/
│   ├── orders/              # Order feature
│   │   ├── data/            # SQLite repo, DB helper
│   │   ├── logic/           # Cubit & states
│   │   └── presentation/    # UI screens (OrderList, AddOrder)
│   │
│   └── reports/             # Reports feature
│       ├── data/            # Report service implementation
│       ├── logic/           # Report cubit & states
│       └── presentation/    # Reports UI
│
├── di/                      # Dependency injection (GetIt setup)
└── main.dart                # App entry point
