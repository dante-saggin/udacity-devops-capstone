# udacity-devops-capstone
Udacity devops capstone

The cloudformation script will create the infrastructure base, I have a shell script to simplify the executinon and it can found at.
```
$./cloudformation/upsert-stack.sh
```

## Cloud Formation Execution
![img-1](./screenshot/1-ExecuteCloudFormatonToCreateAll.png)
## Cloud Formation Console
![img-1](./screenshot/2-FinalExecutionCloudFormation.png)
## Cloud Formation Itens Created
![img-1](./screenshot/3-ItensCreatedByCloudFormation.png)

After the execution of the cloudformation script it's necessary check and deploy the initial revision into the EKS Cluster
### Checking EKS and doing the First deployment.
![img-1](./screenshot/4-FirstTestGettingVersion1Deployed.png)

Creating the pipeline in the Jenkins to execute it should deploy the v2 using a blue/green strategy,
more info on how this strategy work can be found on [Kubernetes-Resources Read me](./kubernetes-resources/)
the revision to deploy and the revision to rollback are controled by the files revision and versionToRollback in the deployments folder

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

A resume of all deployed resources at the end of the process.

![img-1](./screenshot/10-AllResourcesAfterDeployment.png)
