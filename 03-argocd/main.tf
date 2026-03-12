resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.51.6" # Usamos una versión estable

  # Leer repo de K8s automáticamente
  values = [
    <<-EOT
    server:
      # Desactivamos TLS local
      extraArgs:
        - --insecure
      
      # ArgoCD qué repositorio debe vigilar
      additionalApplications:
        - name: open5gs-lab
          namespace: argocd
          project: default
          source:
            repoURL: https://github.com/Gab02022/open5gs-k8s-gcp-test.git
            targetRevision: HEAD
            path: charts/open5gs 
          destination:
            server: https://kubernetes.default.svc
            namespace: open5gs 
          syncPolicy:
            automated:
              prune: true
              selfHeal: true
            syncOptions:
              - CreateNamespace=true 
    EOT
  ]
}