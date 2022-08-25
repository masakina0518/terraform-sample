resource "aws_security_group_rule" "this" {
  security_group_id = var.security_group_this.id
  type              = var.type
  cidr_blocks       = var.cidr_blocks
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
}

# インバウンドルール(ssh)
# resource "aws_security_group_rule" "in_ssh" {
#   security_group_id = aws_security_group.this.id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
# }

# # インバウンドルール(http)
# resource "aws_security_group_rule" "in_http" {
#   security_group_id = aws_security_group.this.id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
# }

# # インバウンドルール(https)
# resource "aws_security_group_rule" "in_https" {
#   security_group_id = aws_security_group.this.id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
# }


# インバウンドルール(pingコマンド用)
# resource "aws_security_group_rule" "in_icmp" {
#   security_group_id = aws_security_group.this.id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = -1
#   to_port           = -1
#   protocol          = "icmp"
# }

# アウトバウンドルール(全開放)
# resource "aws_security_group_rule" "out_all" {
#   security_group_id = aws_security_group.this.id
#   type              = "egress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
# }
