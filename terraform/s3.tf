resource "aws_s3_bucket" "s3_bucket_tf" {
  bucket = "nodejs-20feb-bucket"

  tags = {
    Name        = "NodeJS terraform bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "s3_object_tf" {
  bucket = aws_s3_bucket.s3_bucket_tf.bucket

  for_each = fileset("../public/images", "**")
  key    = "images/${each.key}"
  source = "../public/images"

}