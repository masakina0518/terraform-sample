resource "aws_db_instance" "this" {
  # エディション
  engine = var.engine
  # バージョン
  engine_version = var.engine_version
  # DB インスタンス識別子
  identifier = "${var.project_name}-${var.environment}-db"
  # マスターユーザー名
  username = var.username
  # マスターパスワード
  password = var.password
  # インスタンスクラス
  instance_class = var.instance_class
  # ストレージタイプ
  storage_type = var.storage_type
  # ストレージ割り当て
  allocated_storage = var.allocated_storage
  # ストレージの自動割り当てを有効にする

  # 最大ストレージしきい値
  max_allocated_storage = var.max_allocated_storage
  # マルチAZ
  multi_az = var.multi_az
  # VPC
  # サブネットグループ
  db_subnet_group_name = var.subnet_group_name
  # パブリックアクセス
  #publicly_accessible = var.publicly_accessible
  # セキュリティーグループ
  vpc_security_group_ids = var.vpc_security_group_ids
  #最初のデータベース名
  name = var.name
  # DB パラメータグループ
  parameter_group_name = var.parameter_group_name
  # オプショングループ
  option_group_name = var.option_group_name

  # 自動バックアップの有効化
  ## バックアップ保持期間
  backup_retention_period = var.backup_retention_period
  ## バックアップウィンドウ
  backup_window = var.backup_window
  # スナップショットにタグをコピー
  # copy_tags_to_snapshot = var.copy_tags_to_snapshot
  # 暗号を有効化
  storage_encrypted = var.storage_encrypted
  # マスターキー
  # kms_key_id = var.kms_key_id

  ## 拡張モニタリングの有効化
  # 詳細度
  #monitoring_interval = var.monitoring_interval
  # モニタリングロール
  #monitoring_role_arn = var.monitoring_role_arn
  # ログのエクスポート
  # enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  # マイナーバージョン自動アップグレードの有効化
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  # メンテナンスウィンドウ
  #maintenance_window = var.maintenance_window
  # 削除保護の有効化
  deletion_protection = var.deletion_protection
  # 削除時の最終スナップショット
  skip_final_snapshot = var.skip_final_snapshot
  # 削除時の最終スナップショット識別子
  final_snapshot_identifier = "${var.project_name}-${var.environment}-db-final"
}
