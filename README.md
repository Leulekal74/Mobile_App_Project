# Industrial PPE Compliance & Safety Audit System

A specialized industrial safety application designed for Ethiopian construction and manufacturing firms to manage Personal Protective Equipment (PPE) compliance through digital audit trails.

### Project Group Members
| Full Name | ID Number |
| :--- | :--- |
| Eleni Demlie | UGR/7940/16 |
| Haimanot Beka | UGR/0869/13 |
| Leulekal Walelign | UGR/0922/16 |
| Yabetse Mesfin | UGR/4066/16 |
| Nathnael Belay | UGR/9296/16 |

---

### **Core Application Features**

| Feature Module | Functional Description | CRUD Operations |
| :--- | :--- | :--- |
| **Safety Gear Inventory** | Centralized registry for industrial hardware (Harnesses, Helmets, Boots). | **Create:** Register new safety units. <br> **Read:** View active gear status. <br> **Update:** Modify maintenance logs. <br> **Delete:** Retire damaged equipment. |
| **Daily Inspection Logs** | Digital checklist for supervisors to verify equipment safety before work shifts. | **Create:** Submit daily safety checks. <br> **Read:** Review historical audit data. <br> **Update:** Correct inspection entries. <br> **Delete:** Remove erroneous logs. |

---

### **Technical Requirements Mapping**

* **Authentication & Authorization:** Implements **Signup, Login/Logout, and Delete Account**. Role-based access ensures only "Supervisors" can delete gear records while "Workers" can only submit logs.
* **Architecture:** Strictly follows **Domain-Driven Design (DDD)** with the **BLoC** pattern as specified in the Application Architecture guidelines.
* **Backend:** Powered by a locally hosted **REST API** with a dedicated database (No cloud/Firebase).
* **Testing Protocol:** Includes comprehensive **Unit**, **Widget**, and **Integration** tests for all modules.
* **Project Scope:** This is a niche industrial compliance tool, strictly avoiding common categories like E-commerce, Blogs, or Todo lists.
