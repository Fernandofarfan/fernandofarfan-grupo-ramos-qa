# Grupo Ramos - Infraestructura de SAP CAR QA en GCP

Este repositorio contiene los archivos de configuración de Terraform para desplegar la infraestructura del entorno de Calidad (QA) para **SAP CAR** en Google Cloud Platform (GCP).

## Estructura del Proyecto

El repositorio está organizado de la siguiente manera:

*   [`main.tf`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/main.tf): Configuración del proveedor de Google Cloud e invocación del módulo de cómputo.
*   [`apis.tf`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/apis.tf): Habilitación de las APIs requeridas de Google Cloud (`compute.googleapis.com` e `iap.googleapis.com`).
*   [`variables.tf`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/variables.tf): Declaración de variables globales (zona, estado deseado de las VMs).
*   [`modules/compute/`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/modules/compute): Módulo personalizado que define los recursos de cómputo y almacenamiento:
    *   [`modules/compute/main.tf`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/modules/compute/main.tf): Definición de los recursos de cómputo, data sources de red y discos adjuntos.
    *   [`modules/compute/variables.tf`](file:///c:/Users/ferna/OneDrive/Desktop/fernandofarfan-grupo-ramos-qa/modules/compute/variables.tf): Variables específicas del módulo de cómputo.

## Recursos Desplegados

El módulo de cómputo despliega las siguientes instancias y recursos asociados:

### 1. SAP CAR APP QA (`vhgrrcaqapp01`)
*   **Tipo de máquina:** `n2d-highmem-8`
*   **Sistema Operativo:** SUSE Linux Enterprise Server 15 SP7 for SAP Applications (`suse-sap-cloud/sles-15-sp7-sap`)
*   **Disco de arranque:** 64 GB Hyperdisk Balanced.
*   **Disco adicional:** 512 GB Hyperdisk Balanced para `/usr/sap` (`vhgrrcaqapp01-sap-disk`).
*   **Red:** Conectada a la subred compartida de QA (`gramos-shared-sap-qa-01`) con IP estática interna `10.79.20.10`.

### 2. SAP CAR DB HANA QA (`vhgrrcaqdb01`)
*   **Tipo de máquina:** `m3-ultramem-64` (Optimizada para SAP HANA).
*   **Sistema Operativo:** SUSE Linux Enterprise Server 15 SP7 for SAP Applications (`suse-sap-cloud/sles-15-sp7-sap`)
*   **Disco de arranque:** 64 GB Hyperdisk Balanced.
*   **Discos adicionales (HANA partitions):**
    *   `/usr/sap`: 260 GB (`vhgrrcaqdb01-sap-disk`).
    *   `/hana/data`: 8956 GB (`vhgrrcaqdb01-hana-data-disk`).
    *   `/hana/log`: 512 GB (`vhgrrcaqdb01-hana-log-disk`).
    *   `/hana/shared`: 1024 GB (`vhgrrcaqdb01-hana-shared-disk`).
    *   `/backup`: 6144 GB (`vhgrrcaqdb01-backup-disk`).
*   **Red:** Conectada a la subred compartida de QA (`gramos-shared-sap-qa-01`) con IP estática interna `10.79.20.11`.

---

## Variables de Configuración

| Variable | Descripción | Tipo | Default |
| :--- | :--- | :--- | :--- |
| `desired_status` | Controla el estado de las VMs. Puede ser `RUNNING` o `TERMINATED`. | `string` | `"RUNNING"` |
| `zone` | Zona de GCP elegida para el despliegue con disponibilidad de familias M3. | `string` | `"us-east1-b"` |

---

## Instrucciones de Despliegue

### Requisitos Previos
1. Tener instalado [Terraform](https://www.terraform.io/downloads.html).
2. Tener configuradas las credenciales de acceso a Google Cloud (mediante Application Default Credentials).
   ```bash
   gcloud auth application-default login
   ```

### Pasos
1. **Inicializar Terraform** (para descargar proveedores y módulos):
   ```bash
   terraform init
   ```

2. **Formatear el código** (opcional, para mantener el estándar):
   ```bash
   terraform fmt -recursive
   ```

3. **Ver Plan de Ejecución**:
   ```bash
   terraform plan
   ```

4. **Aplicar los Cambios**:
   ```bash
   terraform apply
   ```
