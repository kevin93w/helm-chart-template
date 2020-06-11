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
3. Update the Values.development.yaml by adding the services you would like to deploy and updating the variables.
4. Run the project or template by using any of the .bat files.

## Supported Kubernetes components
The most basic K8S components are supported, and perhaps I'll add more in the feauture.

#### Global Options
Next to component specific options, there are also some global variables you can set in the Values.yaml file:
- global.environment: The name of the running environment (default "development")
- global.pullPolicy: Defines the pulling strategy when you update your containers
- global.pullSecret: Optional pull secret within your namespace that should be used when fetching the container images from the registry

### Deployment
The deployments enables you to enroll your containers.

#### Options
- service.name: The name of your deployment, this will match the name of the service
- service.image: The base image name
- service.version: The version of the image you would like to deploy
- service.args: An array containing your arguments as strings
- service.env: A list containing your environment variables, every variable should contain a key value pair
- service.ports.internal: The internal port of your container
- service.ports.external: The external port of your container
- service.resources.cpu.request: The CPU request of your container
- service.resources.cpu.limit: The CPU limit of your container
- service.resources.memory.request: The memory request of your container
- service.resources.memory.limit: The memory limit of your container

### Service
The service component makes your deployment available to other containers.

#### Options
- service.name: The name of your service, this will match the name of the deployment
- service.ports.internal: The internal port of your container

### NodePort
In a development environment, it could be desirable to add a NodePort to your service. This will make it available from your local browser. If you change your environment to anything else than "development", this will not be bound to your deployment.

#### Options
- service.name: The name of your service, this will match the name of the deployment
- service.ports.internal: The internal port of your container
- service.ports.external: The external port of your container
- service.ports.node: The NodePort port that you will use to access the container from your browser, this must be >30000.

### Ingress
To make your service available through a hostname, you can add a Ingress router to it. This will not work in the development environment. If you change your environment to anything else than "development", this will be bound to your deployment.

#### Options
- service.name: The name of your service, this will match the name of the deployment
- service.host: The hostname of your service, that will be used to access the service
- service.ports.external: The external port of your container

#### Example Values.<environment>.yaml
```
global:
  environment: development
  pullPolicy: Always
  pullSecret: <pull-secret-name>

services:
  example:
    name: "example"
    image: "nginx"
    version: "latest"
    ports:
      internal: 80
      external: 80
      node: 30001
    resources:
      cpu:
        request: 0.1
        limit: 1.0
      mem:
        request: 64M
        limit: 64M
    args: "['--<argument-1-key>', '<argument-1-value>', '--<argument-2-key>', '<argument-2-value>']"
    env:
      - name: <environment_variable_1_key>
        value: <environment_variable_1_value>
      - name: <environment_variable_2_key>
        value: <environment_variable_2_value>
```
