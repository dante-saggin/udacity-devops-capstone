# udacity-devops-capstone
Udacity devops capstone

The cloudformation script will create the infrastructure base it can be found at.
```
$./cloudformation/upsert-stack.sh
```

## Cloud Formation Execution
![img-1](./screenshot/1-ExecuteCloudFormatonToCreateAll.png)
## Cloud Formation Console
![img-1](./screenshot/2-FinalExecutionCloudFormation.png)
## Cloud Formation Itens Created
![img-1](./screenshot/3-ItensCreatedByCloudFormation.png)

As part of the initial setup I deployed the first version of the code in the EKS cluster
![img-1](./screenshot/4-FirstTestGettingVersion1Deployed.png)

Creating the pipeline in the Jenkins to execute it should deploy the v2 using a blue/green strategy, more info on how this strategy work can be found on [Kubernetes-Resources Read me](./kubernetes-resources/)

### upload docker image
![img-1](./screenshot/5-JenkinsPrint1.png)
### Deploy into the EKS cluster
![img-1](./screenshot/6-JenkinsPrint2.png)
### SmokeTesting
![img-1](./screenshot/7-JenkinsPrint3.png)

After the deployment the image will be uploaded into docker hub
![img-1](./screenshot/8-ImageUpdatedInDockerHub.png)

And the version will return v2 into the /ping
![img-1](./screenshot/9-TestingAfterDeployment.png)

![img-1](./screenshot/10-AllResourcesAfterDeployment.png)


**In order to control the version to be deployed and the version to rollback we have the files revision and versionToRollback in the deployments folder