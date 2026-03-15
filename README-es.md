# 🚀 Laboratorio 5G Cloud-Native: Open5GS y UERANSIM en GCP con GitOps

> 🌐 **Leer en otros idiomas:** [🇺🇸 English](README.md)

Este repositorio contiene la configuración completa de Infraestructura como Código (IaC) y GitOps para desplegar una red 5G Core totalmente funcional (Open5GS) y una red de acceso por radio simulada con teléfonos (UERANSIM) en Google Kubernetes Engine (GKE).

## 🏗️ Arquitectura
* **Proveedor Cloud:** Google Cloud Platform (GCP)
* **Infraestructura como Código (IaC):** Terraform (VPC, Subredes, Clúster GKE, Node Pools)
* **Controlador GitOps:** ArgoCD (desplegado vía Terraform/Helm)
* **5G Core:** Open5GS (gestionado por ArgoCD mediante Helm charts personalizados)
* **5G RAN & UE:** UERANSIM (gestionado por ArgoCD mediante Helm charts personalizados)
* **Automatización:** GitHub Actions (Pipeline CI/CD) con Workload Identity Federation (OIDC)

## ✨ Características Principales
* **Despliegue Zero-Touch:** Toda la infraestructura y las aplicaciones se pueden levantar desde cero utilizando GitHub Actions.
* **Inyección Automática de Datos:** Incluye un Job personalizado de Kubernetes que inyecta automáticamente los datos de los suscriptores (IMSIs y llaves criptográficas) en MongoDB, eliminando la necesidad de abrir túneles manuales a la base de datos.
* **Auto-Recuperación (Self-Healing):** ArgoCD monitorea constantemente el repositorio y el clúster, asegurando que el estado real coincida con la configuración declarativa.
* **Optimización de Costos:** Incluye un pipeline de destrucción para desmantelar completamente el entorno de GCP y evitar facturación no deseada.

## 📂 Estructura del Repositorio (Infraestructura)
Este repositorio contiene puramente el código de infraestructura (IaC) y el inicializador de GitOps. Los manifiestos de las aplicaciones están alojados en un repositorio separado para mantener una arquitectura limpia e independiente.

* `/01-bootstrap`: Configuraciones de Terraform para la inicialización del entorno GCP (Bucket GCS para estado, Service Account, Workload Identity Federation).
* `/02-infra`: Configuraciones de Terraform para la infraestructura base en GCP (VPC, Subredes, Clúster GKE).
* `/03-argocd`: Configuraciones de Terraform para instalar ArgoCD y configurar la sincronización GitOps.
* `/.github/workflows`: Pipelines de GitHub Actions para la creación y destrucción automatizada.
* `Makefile`: Script de automatización local para despliegues rápidos (`make up` / `make down`).

🔗 **Repositorio de Aplicaciones:** Los Helm charts y manifiestos de Kubernetes para Open5GS, UERANSIM y el Job de Python son administrados por ArgoCD desde este repositorio: [Gab02022/open5gs-k8s-gcp-test](https://github.com/Gab02022/open5gs-k8s-gcp-test)

## 🛠️ Fase Cero: El Bootstrap Local
Antes de que GitHub Actions pueda automatizar la infraestructura, necesita una forma de autenticarse en GCP (Workload Identity Federation) y un lugar para guardar el estado de Terraform (Bucket GCS). Debido a que GitHub Actions no puede crear las credenciales que necesita para iniciar sesión, esta fase inicial debe aplicarse localmente.

Desde tu terminal local o Google Cloud Shell, autentícate con tu cuenta de administrador y ejecuta:
```bash
cd 01-bootstrap
terraform init
terraform apply -auto-approve
```

## 🚀 Cómo Desplegar

### Opción 1: Automatizado vía GitHub Actions (Recomendado)
1. Ve a la pestaña **Actions** en este repositorio.
2. Selecciona el flujo de trabajo `Deploy Infrastructure`.
3. Haz clic en **Run workflow**.
4. Disfruta del proceso mientras Terraform y ArgoCD construyen la red 5G.

### Opción 2: Despliegue Local
Asegúrate de tener `gcloud`, `terraform` y `kubectl` instalados y autenticados en tu máquina.
```bash
# Desplegar el entorno completo
make up

# Destruir el entorno completo
make down

```

## 🧪 Verificación

Una vez finalizado el despliegue, verifica que el teléfono 5G virtual (UE) se haya conectado exitosamente al Core y establecido una sesión PDU con acceso a internet:

```bash
# Obtener el nombre del pod del UE
kubectl get pods -n ueransim

# Revisar los logs de conexión
kubectl logs -l <ueransim-ues pod> -n ueransim

```

*Busca el mensaje: `PDU Session establishment is successful`.*

## 🤝 Créditos y Agradecimientos

Este proyecto está inspirado y construido a partir del excelente trabajo de [samuelrojasm/blueprint-aws-tf-bootstrap](https://github.com/samuelrojasm/blueprint-aws-tf-bootstrap). Un enorme agradecimiento a los creadores originales por su esfuerzo en la contenedorización de redes 5G y por compartirlo con la comunidad.
