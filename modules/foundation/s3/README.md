# S3 Terraform Module

## Overview

This module provisions a production-ready Amazon S3 bucket following AWS best practices.

## Features

- Creates an Amazon S3 bucket
- Enables bucket versioning
- Enables server-side encryption using AWS KMS (SSE-KMS)
- Configures lifecycle management
- Enforces HTTPS-only access through a bucket policy
- Applies common resource tags
- Exposes useful outputs

---

## Resources Created

- aws_s3_bucket
- aws_s3_bucket_versioning
- aws_s3_bucket_server_side_encryption_configuration
- aws_s3_bucket_lifecycle_configuration
- aws_s3_bucket_policy
