resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.project_name}-${var.environment}-${var.engine}-cluster"
  replication_group_id = var.elasticache_replication_group_this.id
}
