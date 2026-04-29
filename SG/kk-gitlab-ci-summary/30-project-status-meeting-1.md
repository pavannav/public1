# Session 30: Project Status Meeting - 1

## Node.js Fundamentals

### Key Concepts 💡

Node.js is an open-source runtime environment that allows developers to execute JavaScript code outside of web browsers. It enables building both front-end and back-end applications using a single programming language, leveraging the Chrome V8 JavaScript engine for high performance.

### Installation and Platform Support

Node.js is available for all major platforms:
- Windows
- macOS  
- Various Linux distributions

When installing Node.js, npm (Node Package Manager) is automatically included. npm serves as the primary tool for managing JavaScript packages, libraries, and dependencies in both web and server-side applications.

### Core Components of a Node.js Project

A typical Node.js project structure includes several key files:

1. **package.json**: Metadata file containing project information such as name, version, dependencies, and scripts. This file handles dependency management by clearly declaring external packages needed for development and deployment.

2. **node_modules**: Directory created after running `npm install`. This folder contains all external JavaScript modules and packages required by the project.

3. **index.js**: Main application file where the core business logic resides.

4. **test.js**: File containing test cases that validate the application's functionality.

### Essential npm Commands

> [!IMPORTANT]  
> These commands form the foundation of Node.js project management and testing.

**Installing Dependencies**:
```bash
npm install
```
This command reads the package.json file and downloads/installs all specified dependencies, creating the node_modules directory.

**Running Tests**:
```bash
npm test
```
Executes all test cases defined in the test.js file to ensure code quality and functionality.

**Starting the Application**:
```bash
npm start
```
Launches the Node.js application, typically making it accessible via a web browser on a specific port.

### Practical Workflow

> [!NOTE]  
> In a basic Node.js application (like a "Hello World" example), the workflow follows this sequence:
> 1. Define project structure in package.json
> 2. Run `npm install` to set up dependencies
> 3. Implement logic in index.js and tests in test.js
> 4. Execute `npm test` to validate code
> 5. Use `npm start` to launch and access the application in a browser

### Customization for GitHub Actions

This Node.js foundation will be utilized in upcoming sessions to develop customized GitHub Action workflows, demonstrating how to integrate JavaScript-based automation directly into CI/CD pipelines.

> [!WARNING]  
> Ensure Node.js and npm are properly installed before proceeding with any automation development to avoid runtime errors in deployment environments.
