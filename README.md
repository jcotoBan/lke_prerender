# Linode Prerender Use Case

The idea of this setup is to provide a scalable and reliable way to prerender javascript content in case of bot asks for the content.

If curious about prerendering and SEO, you can check this post: https://www.rankmovers.com/understanding-pre-rendering-in-seo/

## Preparing the setup.

To recreate this setup, you will require:

--> A kubernetes cluster, with right access configured to the api (in this case, a LKE cluster will be used)  

--> kubectl installed  

--> helm installed

--> Certificates for the prerender endpoint. You can bring your own, or generate it with lets encrypt as will be done for this case

--> A domain name you could use for the setup that can resolve. (In this case, Akamai Edge DNS will be used)

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

Verify the pods are running:

```bash
kubectl get pods --namespace cert-manager
```

### 3-Run the cluster issuer

Inside the kubernetes folder, you will find a file named clusterissuer.yaml. An Issuer or ClusterIssuer identifies which Certificate Authority cert-manager will use to issue a certificate.

```bash
cd kubernetes/
```

You can edit the name field, email and privateKeySecretRef as required.

```bash
kubectl apply -f clusterissuer.yaml
```

### 4-Run External DNS

In the same kubernetes folder a file named externaldnssetup.yaml will be found.

You need to run it to be able to generate records for the prerender endpoint, But first you need to edit some fields:

Line 56 - --provider=akamai: In this case, make sure you setup the correct dns server provider, you can check the available providers in here: https://github.com/kubernetes-sigs/external-dns

Line 57 --domain-filter: Make sure you place the domain you want to administer so that external dns dont change any other domain.

In case of Akamai provider, you will need to create a secret with the akamai api credentials required.

```bash
k create secret generic external-dns  \
--from-literal=EXTERNAL_DNS_AKAMAI_SERVICECONSUMERDOMAIN={your Akamai api domain name}  \
--from-literal=EXTERNAL_DNS_AKAMAI_CLIENT_TOKEN={your Akamai api client token}  \
--from-literal=EXTERNAL_DNS_AKAMAI_CLIENT_SECRET={your Akamai api client secret}  \
--from-literal=EXTERNAL_DNS_AKAMAI_ACCESS_TOKEN={your Akamai api client access token} --dry-run=client -o yaml > externa_dns.yaml
```

Then, run it:

```bash
kubectl apply -f external_dns.yaml
```

Check the instructions required according to your dns provider.






