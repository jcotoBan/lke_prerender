# Linode Prerender Use Case

The idea of this setup is to provide a scalable and reliable way to prerender javascript content in case of bot asks for the content.

If curious about prerendering and SEO, you can check this post: https://www.rankmovers.com/understanding-pre-rendering-in-seo/

## Preparing the setup.

To recreate this setup, you will require:

--> A kubernetes cluster, with right access configured to the api (in this case, a LKE cluster will be used)  
--> kubectl installed  
--> helm installed  
--> Certificates for the prerender endpoint. You can bring your own, or generate it with lets encrypt as will be done for this case.

## Arquitecture overview


## Steps

### 1-Install NGINX ingress


```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

```bash
helm repo update
```

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx
```

### 2-Install cert manager (this one in case you dont bring your own script, if that is the case look at step 3)

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml
```

```bash
kubectl create namespace cert-manager
```

```bash
helm repo add cert-manager https://charts.jetstack.io
```

