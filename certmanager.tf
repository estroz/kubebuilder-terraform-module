# TODO: implement Issuer/Certificate as terraform resources.
/*
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: selfsigned-issuer
  namespace: system
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: serving-cert  # this name should match the one appeared in kustomizeconfig.yaml
  namespace: system
spec:
  # $(SERVICE_NAME) and $(SERVICE_NAMESPACE) will be substituted by kustomize
  dnsNames:
  - $(SERVICE_NAME).$(SERVICE_NAMESPACE).svc
  - $(SERVICE_NAME).$(SERVICE_NAMESPACE).svc.cluster.local
  issuerRef:
    kind: Issuer
    name: selfsigned-issuer
  secretName: webhook-server-cert # this secret will not be prefixed, since it's not managed by kustomize
*/
