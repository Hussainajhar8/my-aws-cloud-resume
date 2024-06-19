# AWS Cloud Resume Challenge

This is my attempt at the AWS Cloud Resume Challenge, showcasing my journey in building a dynamic cloud-based resume.

## What is Cloud Resume Challenge?

[The Cloud Resume Challenge](https://cloudresumechallenge.dev/) is a multi-step resume project that aims to build and demonstrate fundamental skills for a career in Cloud. The project was introduced by Forrest Brazeal.

## Architecture

![Architecture Diagram](/front_end/static/assets/images/readme/cloud_resume_architecture.png)

**Services and tools used**:

- Amazon S3 - For static webhosting
- Amazon CloudFront - For content delivery.
- Amazon Certificate Manager - To issue SSL certificates.
- Cloudflare - To register domain and configure DNS records.
- AWS Lambda - To create a visitor count api.
- API Gateway - To act as HTTP gateway that triggers Lambda function
- Dynamo DB - To store the visitor count.
- Terraform - To create consistent and reproduceable deployments.
- GitHub Actions - To automate CI/CD pipeline, ensuring changes are tested, built and deployed efficiently.

## [Live Demo 🔗](https://ajharresume.com)

## Blog

[My Cloud Resume Challenge Journey](https://medium.com/@hussainajhar8/my-cloud-resume-challenge-journey-building-a-fully-automated-portfolio-9b5802badb14)
