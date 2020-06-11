@echo off

echo Deleting all containers...
helm -n helm-chart-example uninstall helm-chart-example
kubectl delete ns helm-chart-example

echo Done...