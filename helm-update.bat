@echo off

echo Updating all containers...

helm upgrade -n helm-chart-example -f .\chart\values.development.yaml -i helm-chart-example .\chart\

echo Done...