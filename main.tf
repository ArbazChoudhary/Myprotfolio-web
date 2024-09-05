resource "aws_s3_bucket" "mybucket" {
    bucket =var.bucketname 
  }

  resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "portfolio" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "portfolio.html"
  source = "portfolio.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_bucket_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "profile-pic.png"
  source = "profile-pic.png"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "devops" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "devops.png"
  source = "devops.png"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "portfolio.html"
  }
   depends_on = [ aws_s3_bucket_acl.example ]
}