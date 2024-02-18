provider "aws" {
  region = "sa-east-1" # São Paulo
}

terraform {
  backend "s3" {
    bucket = "waine-jr-terraform-sa"
    key    = "static-site.tfstate"
    region = "sa-east-1"
  }
}


resource "aws_s3_bucket" "waine_static_website" {
  bucket = "waine-jr-public-site-sa"


  tags = {
    name = "Website S3"
  }
}

resource "aws_s3_bucket_public_access_block" "waine_static_website" {
  bucket = aws_s3_bucket.waine_static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "waine_static_website" {
  bucket = aws_s3_bucket.waine_static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "waine_static_website" {
  depends_on = [aws_s3_bucket_ownership_controls.waine_static_website, aws_s3_bucket_public_access_block.waine_static_website]
  bucket     = aws_s3_bucket.waine_static_website.id
  acl        = "public-read" # Set bucket ACL to allow public read access
}

resource "aws_s3_bucket_website_configuration" "waine_static_website" {
  depends_on = [aws_s3_bucket_acl.waine_static_website]
  bucket     = aws_s3_bucket.waine_static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "waine_static_website" {
  depends_on = [aws_s3_bucket_website_configuration.waine_static_website]
  bucket     = aws_s3_bucket.waine_static_website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  depends_on = [aws_s3_bucket_ownership_controls.waine_static_website, aws_s3_bucket_public_access_block.waine_static_website]
  bucket     = aws_s3_bucket.waine_static_website.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"       = "PublicReadGetObject",
        "Effect"    = "Allow",
        "Principal" = "*",
        "Action"    = "s3:GetObject",
        "Resource"  = "${aws_s3_bucket.waine_static_website.arn}/*"
      }
    ]
  })
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.waine_static_website.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.waine_static_website.website_domain
}