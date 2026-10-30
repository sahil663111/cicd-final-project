# CI/CD Final Project: Building and Deploying a Complete CI/CD Pipeline

[![CI Workflow](https://github.com/sahil663111/cicd-final-project/actions/workflows/workflow.yml/badge.svg)](https://github.com/sahil663111/cicd-final-project/actions/workflows/workflow.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python 3.9](https://img.shields.io/badge/Python-3.9-green.svg)](https://shields.io/)

This repository contains the completed project for the **Continuous Integration and Continuous Delivery (CI/CD)** final project course offered by IBM on Coursera.

## Project Overview

In this project, we build and deploy a complete end-to-end CI/CD pipeline for a containerized microservice:
- **Continuous Integration (CI):** Configured automated testing and code linting workflows using GitHub Actions.
- **Code Quality & Linting:** Automated static syntax checking and PEP8 compliance using `flake8`.
- **Unit Testing:** Automated unit testing and code coverage reports using `nose`.
- **Containerization:** Containerized application using Docker / Buildah exposed on port 8000.
- **Task Automation:** Defined modular, cloud-native Tekton Tasks (`cleanup`, `git-clone`, `flake8`, `nose`, `buildah`, `deploy`).
- **Continuous Delivery (CD):** Constructed an OpenShift Pipeline to automate build, testing, image packaging, and deployment to an OpenShift cluster.
- **Persistent Storage:** Configured OpenShift `PersistentVolumeClaim` (`pipelinerun-pvc`) with the `skills-network-learner` storage class.

## Repository Structure

```text
├── .github/
│   └── workflows/
│       └── workflow.yml        <- GitHub Actions CI workflow definition
├── .tekton/
│   ├── tasks.yml               <- Tekton task definitions (cleanup, nose, flake8)
│   ├── pipeline.yml            <- Tekton pipeline definition
│   └── pvc.yml                 <- PersistentVolumeClaim configuration
├── bin/                        <- Utility and setup scripts
├── deploy/                     <- Kubernetes and OpenShift deployment manifests
├── service/                    <- Python Flask application service package
│   ├── common/                 <- Common error and log handlers
│   ├── config.py               <- App configuration
│   ├── models.py               <- Database models
│   └── routes.py               <- REST API endpoints
├── tests/                      <- Unit tests and test factories
├── Dockerfile                  <- Container image definition
├── requirements.txt            <- Python dependencies
└── README.md                   <- Project documentation and instructions
```

## Running the Application Locally

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the service using Gunicorn on port 8000:
   ```bash
   gunicorn --bind=0.0.0.0:8000 --log-level=info service:app
   ```

## Running Linting and Unit Tests

Execute the following commands to validate code formatting and test coverage:
```bash
# Code style and syntax check
flake8 service tests --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 service tests --count --max-complexity=10 --max-line-length=127 --statistics

# Unit tests with code coverage
nosetests -v --with-spec --spec-color --with-coverage --cover-package=service
```

## Author

- **Sahil**
- GitHub: [@sahil663111](https://github.com/sahil663111)

