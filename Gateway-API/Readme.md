# GKE Gateway API Deployment Guide

This repository provides templates and instructions to deploy a [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) based HTTPS load balancer on Google Kubernetes Engine (GKE), using a reserved global static IP and Google Certificate Manager.

---

## Prerequisites

- **Google Cloud Project** with GKE and appropriate IAM permissions.
- **GKE cluster** (any mode) with Gateway API enabled.
- **kubectl**, **gcloud**, and **Helm** installed on your machine.
- (Optional) **Google Certificate Manager** with a cert map ready for TLS.

---

## 1. Enable Gateway API on GKE

Enable Gateway API (replace placeholders with your actual cluster/region):  
Check if CRDs are installed:

You should see:  
- `gatewayclasses.gateway.networking.k8s.io`
- `gateways.gateway.networking.k8s.io`
- `httproutes.gateway.networking.k8s.io`
- `referencegrants.gateway.networking.k8s.io`

---

## 2. Reserve a Global Static IP

Reserve an IPv4 global static IP for your load balancer:
```bash
gcloud compute addresses create gateway-static-ip
--global
--ip-version=IPV4

gcloud compute addresses describe gateway-static-ip
--global
--format="get(address)"
```  
Note the returned IP value (e.g., `34.107.219.238`).

---

## 3. (Optional) Prepare Certificate Map

If using HTTPS, you must have a [Google Certificate Manager cert map](https://cloud.google.com/certificate-manager/docs/certificate-maps) pre-created (e.g., `nw-devops-map`).  
Set the value in the annotation of the Gateway manifest.

---

## 4. Clone and Configure This Repository

Clone the repository, File: `gateway.yaml` (Helm template)

```bash
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: {{ .Values.gateway.name }}
  namespace: {{ .Values.gateway.namespace }}
  annotations:
    networking.gke.io/certmap: {{ .Values.gateway.certMap }}
spec:
  gatewayClassName: {{ .Values.gateway.gatewayClassName }}
  listeners:
    - name: https
      protocol: HTTPS
      port: 443
      allowedRoutes:
        namespaces:
          from: "All"
  addresses:
    - type: NamedAddress
      value: {{ .Values.gateway.address }}

```
Create a values.yaml file in the same directory with the following example data (update the values as per your environment):
```bash
gateway:
  name: gateway-devops                   # Name for your Gateway resource
  namespace: gateway                     # Namespace to deploy Gateway
  certMap: nw-devops-map                 # Google Certificate Manager's cert map name
  gatewayClassName: gke-l7-global-external-managed  # GKE GatewayClass
  address: gateway-static-ip             # Name of your reserved global static IP address
```

---

## 5. What Happens Next?

- **A new L7 (HTTPS) load balancer is created** pointing to your reserved static IP.
- The **certificate map is attached** for TLS termination.
- **A default backend service is created by GKE that returns 404**, since no `HTTPRoute` is attached yet.
- The load balancer is ready to serve traffic securely, but all requests will receive 404 until you add routes.

---

## 10. Add Routes to Your Gateway

To direct traffic to your application services, create and apply one or more `HTTPRoute` resource(s) targeting this Gateway.  
Example route:
```bash
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: <name-of-your-route>
  namespace: demo
spec:
  parentRefs:
  - name: gateway-devops
    namespace: gateway
  hostnames:
  - <yourdomain.com>
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: <service-name>
      port: <service.port>

```
---

## Troubleshooting

- **404 responses** indicate the Gateway is up, but routing isn't configured yet.
- The external IP in `kubectl get gateway` should match your reserved static IP.
- Certificates must be provisioned and mapped before traffic goes secure.
- Check Gateway and related events using `kubectl describe`.

---

## References

- [GKE Gateway API Documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways)
- [Gateway API Project Docs](https://gateway-api.sigs.k8s.io/guides/)
- [Certificate Manager Documentation](https://cloud.google.com/certificate-manager/docs/)

---

_This README provides all steps to help new team members or contributors clone, configure, and deploy a secure Gateway API-based L7 load balancer in GKE._
