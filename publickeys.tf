resource "aws_key_pair" "nkpEW" {
  key_name   = "Ewan-key-pair"
  public_key = var.publickey
}
