# Sentinela Exams DB

A database migration and management project for SwissAnalytica's sentinela platform, focused on storing, processing, and reviewing medical exam data and machine learning diagnoses. This repository contains SQL migrations, configuration files, and quality assurance integrations for the core exam data pipeline.

## Table of Contents
1. 📝 [Project Summary](#project-summary)
2. 🚀 [Features](#features)
3. 🏗️ [Architecture & Tech Stack](#architecture--tech-stack)
4. 🛠️ [Installation](#installation)
5. 💻 [Local Development](#local-development)
6. ⚙️ [Configuration](#configuration)
7. ✅ [Quality Assurance](#quality-assurance)
8. 🧪 [Testing](#testing)
9. 📋 [Logs](#logs)
10. 🔄 [CI/CD](#cicd)
11. 📁 [Project Structure](#project-structure)

---

## 📝 Project Summary
This repository manages the database schema and migrations for the sentinela Exams system, which ingests medical exam data from hospitals, processes it with machine learning models, and enables medical professionals to review and validate results. It is a foundational component for data integrity, traceability, and compliance in the sentinela platform.

## 🚀 Features
- SQL migrations for all core tables: exams, exam_diagnoses, exam_results, medical_reviews_log
- ENUM types for exam and review classification
- Indexes for optimized query performance
- Foreign key constraints for data integrity
- Value range checks for result normalization
- Audit log for medical professional reviews

## 🏗️ Architecture & Tech Stack
- **Database:** PostgreSQL (SQL migrations)
- **Quality Assurance:** SonarQube (via SonarCloud)
- **CI/CD:** GitHub Actions
- **Cloud Deployment:** GCP (Google Cloud Platform)
- **Version Control:** Git

## 🛠️ Installation
- Ensure PostgreSQL is installed (version 16.0)
- Clone this repository

## 💻 Local Development
- Run migrations using your preferred PostgreSQL migration tool (e.g., `psql`, `flyway`, or Dockerized Postgres)

## ⚙️ Configuration
- Environment variables: see `.env` (ignored in version control)
- Database connection settings: configure in your migration tool
- SonarQube: see `sonar-project.properties`

## ✅ Quality Assurance
- Integrated with SonarQube via SonarCloud (`sonar-project.properties`)
- Automated code analysis for SQL and supporting files

## 🔄 CI/CD
- GitHub Actions workflow:
  - Build
  - SonarQube push
  - GCP deploy
- All code changes require PR and CODEOWNERS approval for both develop and production branches.

## 📁 Project Structure
- `migrations/` — SQL migration scripts (e.g., `20250901_start_project.sql`)
- `.gitignore` — Ignore venv, .env, and system files
- `sonar-project.properties` — SonarQube configuration
- `.github/` — [GitHub Actions workflows, CODEOWNERS, etc.]

---

© swissanalytica — All rights reserved.
