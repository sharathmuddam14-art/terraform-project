# Secrets Manager Terraform Module

## Overview

This module creates and manages AWS Secrets Manager secrets using Terraform. It provisions the secret, stores its value, encrypts it using a customer-managed AWS KMS key, attaches a resource policy, and exports useful outputs for use by other Terraform modules.

---

## Features

- Creates AWS Secrets Manager secrets
- Stores secret values securely
- Encrypts secrets using a customer-managed KMS key
- Supports secret versioning
- Attaches a resource policy
- Applies common tags
- Exports secret information through outputs

---

## Resources Created

- aws_secretsmanager_secret
- aws_secretsmanager_secret_version
- aws_secretsmanager_secret_policy

---
