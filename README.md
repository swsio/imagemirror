# Image Mirroring as CronJob in OpenShift 📦 👉 📦
## Why use this?
Since Docker Hub is restricting the requests you can send to their registry there are some problems with images 📦 that are only available on Docker Hub but engines, plattforms or deployments can not handle logins right or provide them as part of your project, that can cause problems. A solution is to mirror these images to some other not restricted or internal registry. This solution should work on K8S too but is originally developed to work on OpenShift/OKD Container Plattform. You have to use your personal Docker Hub Account to overcome the pull rate limit!

### PREREQUISITES
- Paid personal Docker Hub Account
- Destination Registry
- Access to quay.io to pull my image or build your own with included Dockerfile 🛳️

## Setup
This solution is designed to be highly flexible, so it is possible to change the function of the whole solution without the need to change the container image.

### Working Parts
* ConfigMap with ENV to provide credentials and parameter:
    - file: configmap-env-sample.yaml
    - copy and edit ✏️ this with your own credentials
* ConfigMap with runtime information:
    - file: configmap-config.yaml
    - only edit if you want to change the functionality 
* ConfigMap with list of images to mirror:
    - file: configmap-list-sample.yaml
    - copy and edit ✏️ this with your own repositories you want to mirror
    - can contain several repositories, see examples for inspiration 🌟
* Cronjob as container 🚢
    - file: cronjob.yaml
    - edit ✏️ file to adjust runtime, see [Crontab Guru](https://crontab.guru/#5_1_*_*_*) for syntax
    - TIP 💡: Watch for time to complete all your images and adjust runtimes per day, I recommend once a day (example 5 minutes after 1am)

### Get things going 💻
- Adjust the ressources according to your needs
- Create namespace on your cluster
- Apply the ressources to your cluster

## TLDR
1. COPY and EDIT configmap-env-sample.yaml to configmal-env.yaml
2. COPY and EDIT configmap-list-sample.yaml to configmal-list.yaml
3. APPLY ressources
- oc create project openshift-cron-jobs
- oc create -f configmap-env.yaml
- oc create -f configmap-config.yaml
- oc create -f configmap-list.yaml
- oc create -f cronjob.yaml

## Problem 🔥 & Solution 🔨
Maybe you have to adjust the SCC to make the container run depending on your setup
### Example
oc adm policy add-scc-to-user anyuid -z default -n openshift-cron-jobs

# Credits
As this solution is developed by me the used tool to do the hard work is skopeo

[![Skopeo Logo](https://cdn.rawgit.com/containers/skopeo/master/docs/skopeo.svg)](https://github.com/containers/skopeo)

This is also a good start to adjust the tasks the solution can provide with all the parameters and features skopeo can provide 😃 

# Copyright
Please do not use or recycle my code without my permission - feel free to contact 📫 me!