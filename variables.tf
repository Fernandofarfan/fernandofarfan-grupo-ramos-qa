variable "desired_status" {
  description = "Estado de las VMs (RUNNING o TERMINATED)"
  type        = string
  default     = "RUNNING"
}

variable "zone" {
  description = "Zona con disponibilidad para la máquina M3 de ultra memoria"
  type        = string
  default     = "us-east1-b"
}
