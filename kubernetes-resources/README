Blue/green Deployment Example
=================================================

> Here is  release a new version of a single service using the
blue/green deployment strategy.

## Steps to follow

1. version 1 is serving traffic
1. deploy version 2
1. wait until version 2 is ready
1. switch incoming traffic from version 1 to version 2
1. shutdown version 1

## In practice

```bash
# Deploy the first application
$ kubectl apply -k ./kubernetes-resources/

# Test if the deployment was successful
$ curl $(minikube service flask-app --url)
2018-01-28T00:22:04+01:00 - Host: host-1, Version: v1.0.0

# To see the deployment in action, open a new terminal and run the following
command:
$ watch kubectl get po

# Then deploy version 2 of the application
$ kubectl apply -f ./kubernetes-resources/v2/deployment.yaml

# Wait for all the version 2 pods to be running
$ kubectl rollout status deploy flask-app-v2 -w
deployment "flask-app-v2" successfully rolled out

# Side by side, the pods will be running both in version 1 and version 2, but the traffic is going to version 1


# Using the command below we will change the loadbalance to send traffic to all pods with label version=v2.0.0
$ kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/v2/service-patch.yaml)"

# Test if the second deployment was successful
$ service=$(minikube service flask-app --url)/ping
$ while sleep 0.1; do curl "$service"; done

# in order to rollback to the previous version
$ kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/v2/service-patch-rollback.yaml)"

# If everything is working as expected, you can then delete the v1.0.0
# deployment
$ kubectl delete deploy flask-app-v1
```

### Cleanup

```bash
$ kubectl delete all -l app=flask-app
```
