# Bank MVC - Bank Card Management System

## Overview

Bank MVC is a comprehensive web-based banking card management system built with Spring Boot, implementing the Model-View-Controller (MVC) architecture pattern. The application provides both traditional web interface using FreeMarker templates and RESTful API endpoints for managing bank cards, users, transactions, and card applications.

## Target Audience

### Primary Users
- **Bank Employees** - Administrative staff who manage user accounts, approve/reject card applications, and oversee system operations
- **Bank Customers** - End users who apply for cards, view their card details, check balances, and perform transfers
- **System Administrators** - Technical staff responsible for system maintenance and user management

### Secondary Users
- **API Consumers** - Third-party applications or services that integrate with the banking system via REST APIs
- **Developers** - Software developers who maintain, extend, or integrate with the system

## System Purpose

The Bank MVC system serves multiple critical banking functions:

### Core Banking Operations
- **Card Lifecycle Management** - From application submission to card activation, blocking, and closure
- **Financial Transactions** - Secure money transfers between cards with full audit trails
- **User Account Management** - Complete user profile management with role-based access control
- **Application Processing** - Streamlined workflow for card application approval/rejection

### Administrative Functions
- **User Administration** - Account activation/deactivation, role management, and user oversight
- **Transaction Monitoring** - Real-time transaction tracking and status management
- **System Security** - Secure authentication, data encryption, and access control

## Technology Stack

### Core Framework
- **Spring Boot 3.2.0** - Primary application framework
- **Java 17** - Programming language and runtime environment
- **Maven** - Dependency management and build automation

### Web & API Technologies
- **Spring MVC** - Web framework for traditional web pages
- **Spring REST** - RESTful API implementation
- **FreeMarker** - Template engine for server-side rendering
- **Vanilla JS** - Client-side scripting and dynamic interactions
- **Bootstrap 5.3.0** - Frontend CSS framework
- **Swagger/OpenAPI 3** - API documentation and testing interface

### Data & Persistence
- **Spring Data JPA** - Object-relational mapping and data access
- **PostgreSQL** - Production database system
- **H2 Database** - In-memory database for testing
- **Liquibase** - Database version control and migration management

### Security & Authentication
- **Spring Security** - Authentication and authorization framework
- **Basic Authentication** - API security mechanism
- **BCrypt** - Password hashing algorithm
- **Custom Encryption** - Card number encryption for data protection

### Testing & Quality Assurance
- **JUnit 5** - Unit testing framework
- **Mockito** - Mocking framework for isolated testing
- **Spring Boot Test** - Integration testing support
- **TestContainers-compatible** - Database testing setup

## Architecture & Design Patterns

### MVC Architecture
- **Model** - JPA entities (User, Card, Transaction, CardApplication)
- **View** - FreeMarker templates with responsive Bootstrap UI
- **Controller** - Separate web controllers and REST controllers

### Key Design Patterns
- **Repository Pattern** - Data access abstraction with Spring Data JPA
- **Service Layer Pattern** - Business logic encapsulation
- **DTO Pattern** - Data transfer objects for API responses
- **Specification Pattern** - Dynamic query building with JPA Criteria API
- **Builder Pattern** - Entity construction (using Lombok)

### Security Implementation
- **Role-Based Access Control (RBAC)** - USER and ADMIN roles
- **Method-Level Security** - @PreAuthorize annotations
- **Data Encryption** - Sensitive card information protection
- **SQL Injection Prevention** - Parameterized queries via JPA

## Algorithms & Methodologies

### Card Number Generation
- **Luhn Algorithm** - Card number validation
- **Encryption Algorithm** - AES encryption for card number storage
- **Random Generation** - Secure card number generation with validation

### Transaction Processing
- **Atomic Transactions** - Database ACID compliance
- **Balance Validation** - Insufficient funds checking
- **Idempotency** - Duplicate transaction prevention
- **State Machine** - Transaction status management (PENDING → SUCCESS/FAILED)

### Search & Filtering
- **JPA Specifications** - Dynamic query building
- **Pagination** - Performance optimization for large datasets
- **Sorting** - Multi-criteria sorting implementation

### Audit & Compliance
- **Entity Auditing** - Automatic timestamp tracking
- **Transaction Logging** - Complete audit trail
- **Data Masking** - Sensitive information protection in logs

## Project Structure

```
src/
├── main/
│   ├── java/kg/manurov/bankmvc/
│   │   ├── config/          # Configuration classes
│   │   ├── controllers/     # Web and REST controllers
│   │   │   ├── rest/       # REST API endpoints
│   │   │   └── web/        # MVC web controllers
│   │   ├── dto/            # Data Transfer Objects
│   │   ├── entities/       # JPA entity classes
│   │   ├── enums/          # System enumerations
│   │   ├── repositories/   # Data access layer
│   │   ├── service/        # Business logic layer
│   │   └── util/           # Utility classes
│   └── resources/
│       ├── db/migrations/  # Liquibase database migrations
│       ├── templates/      # FreeMarker templates
│       │   ├── admin/     # Admin interface templates
│       │   ├── user/      # User interface templates
│       │   └── layouts/   # Layout templates
│       └── static/        # CSS, JS, images
└── test/                  # Test classes and resources
```

## How to Execute

### Prerequisites
- **Java 17** or higher
- **PostgreSQL 12+** database server
- **Maven 3.6+** build tool
- **Git** for version control

### Environment Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd Bank-mvc
   ```

2. **Database Setup**
   ```bash
   # Create PostgreSQL database
   createdb bank_mvc_db
   
   # Create user (optional)
   psql -c "CREATE USER bank_user WITH PASSWORD 'your_password';"
   psql -c "GRANT ALL PRIVILEGES ON DATABASE bank_mvc_db TO bank_user;"
   ```

3. **Environment Configuration**

   Create `.env.local` file in project root:
   ```.env.local
   # Database Configuration
   DB_URL={your db url}
   DB_USERNAME={username}
   DB_PASSWORD={password}

   # Encryption Configuration
   ENCRYPTION_KEY={encryption key}

   # Application Configuration
   SERVER_PORT={your port}
   APP_EXPIRY_DATE={expiry date for cards}
   SERVER_CONTEXT_PATH={rest api path}

   # Logging Configuration
   LOG_LEVEL_ROOT={choose your LOG_LEVEL_ROOT}
   LOG_LEVEL_APP={choose your LOG_LEVEL_APP}
   LOG_FILE_PATH=logs{path for saving your logs}
   ```

### Build and Run

#### Option 1: Maven Build
```bash
# Clean and build
mvn clean compile

# Run database migrations
./run-liquibase.sh

# Start application
mvn spring-boot:run
```

#### Option 2: JAR Execution
```bash
# Build JAR file
mvn clean package

# Run application
java -jar target/bankmvc-0.0.1-SNAPSHOT.jar
```

#### Option 3: IDE Execution
- Import project into IntelliJ IDEA or Eclipse
- Configure environment variables
- Run `BankMvcApplication.main()` method

### Testing

```bash
# Run all tests
mvn test

# Run specific test class
#Unit tests:
mvn test -Dtest=CardApplicationServiceTest
mvn test -Dtest=UserServiceTest
#Inegration tests:
mvn test -Dtest=RestApplicationControllerTest
mvn test -Dtest=ApplicationControllerTest
mvn test -Dtest=ApplicationRepositoryTest

```

### Access Points

After successful startup, access the application at:

- **Web Interface**: `http://localhost:8080`
- **API Documentation**: `http://localhost:8080/api/v1/swagger-ui.html`
- **API Endpoints**: `http://localhost:8080/api/v1/*`

### Default Login Credentials

**Administrator:**
- Phone: `+7(900)1234567`
- Password: `qwe`

**Regular User:**
- Phone: `+7(900)1234568`
- Password: `qwe`

### Database Migration

```bash
# Run migrations manually
./run-liquibase.sh

# Rollback to previous version
mvn liquibase:rollback -Dliquibase.rollbackCount=1
```

## API Documentation

The system provides comprehensive REST API documentation accessible via Swagger UI. Key endpoints include:

- **Authentication**: Basic Auth required for all API calls
- **Card Management**: `/api/v1/cards/*`
- **User Management**: `/api/v1/users/*`
- **Transactions**: `/api/v1/transactions/*`
- **Applications**: `/api/v1/applications/*`

## Development Notes

### Code Style
- All code comments and documentation in English
- Lombok used for reducing boilerplate code
- Service layer handles all business logic
- Controllers act as thin layer between web/API and services

### Security Considerations
- Card numbers are encrypted in database
- Passwords use BCrypt hashing
- Role-based access control implemented
- SQL injection prevention via JPA
- Input validation on all endpoints

### Performance Optimization
- Database indexing on frequently queried fields
- Pagination implemented for large datasets
- Lazy loading for JPA relationships
- Connection pooling configured

## Contributing

1. Follow existing code style and patterns
2. Write unit tests for new functionality
3. Update documentation for API changes
4. Use English for all code comments and documentation
5. Ensure database migrations are backwards compatible

## Support

For technical issues or questions:
- **Email**: out1of1mind1exception@gmail.com
- **GitHub**: https://github.com/DesBasito
- **Documentation**: Check Swagger UI for API details