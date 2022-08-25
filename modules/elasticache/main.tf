resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.project_name}-${var.environment}-${var.engine}"
  replication_group_description = "${var.project_name}-${var.environment}-${var.engine}"
  engine                        = var.engine
  node_type                     = var.node_type
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name
  number_cache_clusters         = var.number_cache_clusters
  automatic_failover_enabled    = var.number_cache_clusters == 1 ? false : true
  subnet_group_name             = var.subnet_group_name
  security_group_ids            = var.security_group_ids
  apply_immediately             = var.apply_immediately

  # クラスターモードの場合
  # cluster_mode {
  #   num_node_groups         = 3 # shard number
  #   replicas_per_node_group = 2 # replica per shard num
  # }

  # lifecycle {
  #   ignore_changes = var.use_clustor ? ["number_cache_clusters"] : null
  # }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.engine}"
    Environment = var.environment
    Project     = var.project_name
    Engine      = var.engine
  }
}
