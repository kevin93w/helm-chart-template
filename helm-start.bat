@echo off

kubectl create ns helm-chart-example >nul 2>&1

helm install -n helm-chart-example -f .\chart\values.development.yaml helm-chart-example .\chart\

echo Done...