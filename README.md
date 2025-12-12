# Equb and Idir Management System

## Project Overview

The **Equb and Idir Management System** is a web-based application designed to digitalize and streamline the operations of two traditional Ethiopian community support systems: **Equb** (rotating savings and credit association) and **Idir** (community association for social support and funeral expenses).

This system aims to replace manual, notebook-based record-keeping with a comprehensive digital platform to improve **accuracy, transparency, and efficiency** in managing member contributions, rotation schedules, and expenses.

## Technology Stack

The project is built using a standard Java Enterprise stack:

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Backend** | Java Servlets | Handles business logic, request processing, and data flow. |
| **Database** | MySQL | Securely stores all member, contribution, rotation, and expense data. |
| **Frontend** | JSP (JavaServer Pages) | Used for dynamic presentation of the user interface (Admin and Member dashboards). |
| **Build Tool** | Apache Maven | Manages project dependencies, compilation, and packaging. |

## Key Features

The system supports two main actors: **Admin** and **Member**, with role-based access control.

### Admin Functionalities
*   **Member Management:** Add, update, and delete members; assign members to Equb/Idir groups.
*   **Equb Management:** Create groups, record contributions, manage rotation schedules (fixed or random).
*   **Idir Management:** Create groups, set monthly contribution rates, track payments, and manage fund balance.
*   **Expense Management:** Record and track expenses related to Idir support.
*   **Reporting:** Generate comprehensive reports (payment status, rotation reports, expense summaries).

### Member Functionalities
*   **Authentication:** Secure login with phone number and password.
*   **Personal Dashboard:** View payment history, next contribution date, and Equb rotation position.
*   **Profile Management:** Update personal information.

## Project Structure

This project follows the standard **Maven-based Java Web Application** directory structure. The core logic is separated into distinct packages for maintainability and adherence to the Model-View-Controller (MVC) architectural pattern.

```
equb-idir-management-system/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── equbidir/
│       │           ├── controller/  # Java Servlets (C in MVC)
│       │           ├── model/       # POJOs/Entities (M in MVC)
│       │           ├── dao/         # Data Access Objects
│       │           └── util/        # Utility classes (e.g., DB connection, security)
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml          # Deployment Descriptor
│           ├── assets/
│           │   ├── css/             # Stylesheets (style.css)
│           │   └── js/              # JavaScript files (main.js)
│           │   └── views/
│           │       ├── auth/        # Login, Logout, Registration (login.jsp)
│           │       ├── admin/       # Admin-specific JSPs (dashboard.jsp, member_management.jsp)
│           │       └── member/      # Member-specific JSPs (dashboard.jsp, profile.jsp)
│           └── index.jsp            # Landing page
├── pom.xml                      # Maven Project Object Model file
├── README.md                    # Project documentation (this file)
└── .gitignore                   # Files to ignore in version control
```

### Key Directories and Files

| Path | Purpose |
| :--- | :--- |
| `src/main/java/com/equbidir/controller` | Contains all **Java Servlets** responsible for handling HTTP requests and responses (e.g., `LoginServlet`, `AdminDashboardServlet`). |
| `src/main/java/com/equbidir/model` | Contains **Plain Old Java Objects (POJOs)** representing database entities (e.g., `Member`, `EqubGroup`, `Contribution`). |
| `src/main/java/com/equbidir/dao` | Contains **Data Access Objects (DAOs)** for abstracting and managing database operations (e.g., `MemberDAO`, `ContributionDAO`). |
| `src/main/webapp/views` | Contains all **JSP files** which serve as the View layer in the MVC pattern. |
| `src/main/webapp/WEB-INF/web.xml` | The **Deployment Descriptor** for the web application, configuring servlets, filters, and welcome files. |
| `pom.xml` | Defines project dependencies (e.g., Servlet API, MySQL Connector) and build configuration. |

## Getting Started

1.  **Prerequisites:** Ensure you have a Java Development Kit (JDK 8+), Apache Maven, and a compatible IDE (e.g., IntelliJ IDEA, Eclipse) installed.
2.  **Clone the Repository:**
    ```bash
    git clone [REPOSITORY_URL]
    cd equb-idir-management-system
    ```
3.  **Build the Project:**
    ```bash
    mvn clean install
    ```
4.  **Deployment:** Deploy the generated `.war` file to an application server (e.g., Apache Tomcat).
5.  **Database Setup:** Create the `equb_idir_db` database in MySQL and run the necessary schema scripts (to be added).
