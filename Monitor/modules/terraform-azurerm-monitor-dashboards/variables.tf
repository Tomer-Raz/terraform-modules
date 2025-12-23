variable "dashboard_files_folder_path" {
  description = "Path to the folder containing dashboard JSON files"
  type        = string
  default     = "./dashboards/config"
}

variable "dashboards" {
  type = any
}