# TibebArchive: Traditional Textile Technical Registry

A specialized ethnographic documentation platform designed for researchers and textile students to archive the technical specifications of traditional Ethiopian weaving patterns and natural dye formulas.

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
| **Pattern Specification Registry** | A technical database for weaving patterns (e.g., Tilf, Tibeb styles) including thread counts and geometry. | **Create:** Log new pattern designs. <br> **Read:** View technical metadata. <br> **Update:** Edit design specifications. <br> **Delete:** Remove obsolete records. |
| **Material & Dye Records** | A specialized service for documenting yarn types and traditional natural dye recipes. | **Create:** Archive new dye formulas. <br> **Read:** Search material properties. <br> **Update:** Refine chemical/natural ratios. <br> **Delete:** Clean up duplicate entries. |
| **Artisan Directory** | A profile system for traditional weavers, tracking their location and specific weaving specialties. | **Create:** Register a new artisan. <br> **Read:** Search weavers by region. <br> **Update:** Edit contact info. <br> **Delete:** Remove profiles. |
---

### **Technical Requirements Mapping**

* **Authentication & Authorization:** Implements **Signup, Login/Logout, and Delete Account**. Role-based access ensures "Lead Designers" can manage all records, while "Textile Students" are restricted from deleting master data.
* **Architecture:** Strictly follows **Domain-Driven Design (DDD)** with the **BLoC** pattern as specified in the Application Architecture guidelines.
* **Backend:** Powered by a **locally hosted REST API** and database. No third-party hosting or Firebase is utilized, meeting the strict local-hosting requirement.
* **Testing Protocol:** Includes comprehensive **Unit, Widget, and Integration tests** to ensure the integrity of the archive data.
* **Project Scope:** This is a niche cultural preservation tool, strictly avoiding common categories like E-commerce, Blogs, or Todo lists.
