# How to play

Deploy

``` bash
# add issuer
kubectl apply -f ./issuer-prod.yaml
#install helm chart
helm install install test .  --debug --set connection_string=$TF_VAR_connection_string

```

``` bash
# add record
curl -H 'Content-Type: application/json' -d "{\"name\":\"Yagr\", \"address\":\"Frankfurt am Main\"}" demo02-ingress.yagr.xyz/api/add

# check result
curl demo02-ingress.yagr.xyz/api/

```
