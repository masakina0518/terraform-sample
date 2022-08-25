variable "project_name" {}

variable "environment" {}

variable "name" {}

variable "fifo_queue" { default = false }
#可視性タイムアウト（タイムアウト時デッドレターキューに移動する）
variable "visibility_timeout_seconds" { default = 30 }
#メッセージ保持期間
variable "message_retention_seconds" { default = 86400 }
#配信遅延
variable "delay_seconds" { default = 10 }
#最大メッセージサイズ
variable "max_message_size" { default = 2048 }
#メッセージ受信待機時間
variable "receive_wait_time_seconds" { default = 10 }

#デッドレターキュー最大受信数
variable "maxReceiveCount" { default = 5 }
