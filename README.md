# Helm Chart Template
Setup that contains predefined helm chart templates that make use of the Values file to generate deployments; ingress networks; nodeports and other Kubernetes components.

## What does it do?
This template aims to make use of predefined templates as much as possible to construct a Kubernetes specification file, based on variables set in the Values.yaml file.
By changing the variables in the Values file, the template will automatically be updated.

The .bat scripts in those project are added for convencience, they help you to easily start up your services in your cluster in the correct namespace.

helm-start.bat - Initializes the namespace and starts up the containers using the Helm chart and Values.development.yaml
helm-update.bat - Updates the existing containers using the Helm chart and Values.development.yaml (e.g. when you have updated environment variables)
helm-stop.bat - Shuts down your running containers within the namespace and destroys the namespace after it has finished.
helm-template.bat - This performs a dry run of the Helm chart and outputs the Kubernetes specification file as 'output.txt' in your repository. You can use this to check if you set everything up correctly.

## Usage
This template helps you to make use of Helm more easily. 
1. Copy the contents of this repository into your own project.
2. Update the namespaces in the .bat scripts.
3. Update the Values.development.yaml variables.
4. Run the project or template by using any of the .bat files.
