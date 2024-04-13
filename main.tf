resource "aws_s3_bucket" "burrabucket" {
  bucket = var.bucketname


}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.burrabucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.burrabucket.id

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

  bucket = aws_s3_bucket.burrabucket.id
  acl    = "public-read"

}
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.burrabucket.id
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.burrabucket.id
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.burrabucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.example]
}