# 2. Inyectar Apps (Core 5G y UERANSIM) automáticamente
resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version    = "1.6.2" 
  
  depends_on = [helm_release.argocd]

  values = [
    <<-EOT
    applications:
      # 1. El Core 5G (Open5GS)
      - name: open5gs
        namespace: argocd
        project: default
        source:
          repoURL: 'https://github.com/Gab02022/open5gs-k8s-gcp-test.git'
          targetRevision: HEAD
          path: charts/open5gs
        destination:
          server: 'https://kubernetes.default.svc'
          namespace: open5gs
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
            - CreateNamespace=true

      # 2. UERANSIM - (gNodeB)
      - name: ueransim-gnb
        namespace: argocd
        project: default
        source:
          repoURL: 'https://github.com/Gab02022/open5gs-k8s-gcp-test.git'
          targetRevision: HEAD
          path: charts/ueransim-gnb 
        destination:
          server: 'https://kubernetes.default.svc'
          namespace: ueransim     
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
            - CreateNamespace=true

      # 3. UERANSIM - (UEs)
      - name: ueransim-ues
        namespace: argocd
        project: default
        source:
          repoURL: 'https://github.com/Gab02022/open5gs-k8s-gcp-test.git'
          targetRevision: HEAD
          path: charts/ueransim-ues 
        destination:
          server: 'https://kubernetes.default.svc'
          namespace: ueransim  
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
            - CreateNamespace=true
    EOT
  ]
}