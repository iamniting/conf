## AWS Installation

### Create a provider cluster using below install config

```yaml
apiVersion: v1
baseDomain: <base-domain>
compute:
- architecture: amd64
  hyperthreading: Enabled
  name: worker
  platform:
    aws:
      type: m5.4xlarge
      zones:
      - us-east-1a
      - us-east-1b
      - us-east-1c
  replicas: 4
controlPlane:
  architecture: amd64
  hyperthreading: Enabled
  name: master
  platform: {}
  replicas: 3
metadata:
  name: <provider-name>
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineNetwork:
  - cidr: 10.0.0.0/16
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  aws:
    region: us-east-1
publish: External
pullSecret: <pull-secrets>
```

### Get provider security group using the provider name used in above install config

```console
$ aws ec2 describe-security-groups --output json --filters Name=tag:Name,Values=<provider-name>-*-worker-sg --query 'SecurityGroups[*].{ID:GroupId,Tags:Tags[?Key==`Name`].Value}' | jq '.[] | .ID'

"sg-02b8ceae0871d5de2"
```

### Open the ports of provider cluster using security group from above command output

```console
$ GROUP_ID=sg-02b8ceae0871d5de2
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --cidr 10.0.0.0/16 --port 31659
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --cidr 10.0.0.0/16 --port 9283
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --cidr 10.0.0.0/16 --port 6789
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --cidr 10.0.0.0/16 --port 3300
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --cidr 10.0.0.0/16 --port 6800-7300

True
SECURITYGROUPRULES	10.0.0.0/16	31659	sg-02b8ceae0871d5de2	269733383066	tcp	False	sgr-0a75ac8849e38de4b	31659
True
SECURITYGROUPRULES	10.0.0.0/16	9283	sg-02b8ceae0871d5de2	269733383066	tcp	False	sgr-0e38870c01925adcd	9283
True
SECURITYGROUPRULES	10.0.0.0/16	6789	sg-02b8ceae0871d5de2	269733383066	tcp	False	sgr-0f8d6f99a6feaae23	6789
True
SECURITYGROUPRULES	10.0.0.0/16	3300	sg-02b8ceae0871d5de2	269733383066	tcp	False	sgr-0fdb60b97df82a905	3300
True
SECURITYGROUPRULES	10.0.0.0/16	6800	sg-02b8ceae0871d5de2	269733383066	tcp	False	sgr-03f172b7d20a0207f	7300
```

### Get subnets of provider cluster

```console
$ aws ec2 describe-subnets --output json --filters Name=tag:Name,Values=<provider-name>* --query 'Subnets[*].{ID:SubnetId,Tags:Tags[?Key==`Name`].Value}' | jq '.[] | .ID'

"subnet-04b68440d1f8f2785"
"subnet-02d88ef644e18b6ee"
"subnet-09950eafc4eaea733"
"subnet-08e045a3c21c9764c"
"subnet-03e8bdadfe72a23d0"
"subnet-0c095e9891cf2cf6e"
```

### Replace the subnets in the consumer install config under platform section and create the consumer cluster

```yaml
apiVersion: v1
baseDomain: <base-domain>
compute:
- architecture: amd64
  hyperthreading: Enabled
  name: worker
  platform:
    aws:
      type: m5.4xlarge
      zones:
      - us-east-1a
      - us-east-1b
      - us-east-1c
  replicas: 4
controlPlane:
  architecture: amd64
  hyperthreading: Enabled
  name: master
  platform: {}
  replicas: 3
metadata:
  creationTimestamp: null
  name: <consumer-name>
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineNetwork:
  - cidr: 10.0.0.0/16
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  aws:
    region: us-east-1
    subnets:
    - subnet-0adf1b0a06825a214
    - subnet-06bccfd882568271c
    - subnet-04ec6ecd11fc5a480
    - subnet-032825067efe796cf
    - subnet-0e55d873a2c3bb8d5
    - subnet-057b2f7e1a9e5abd3
publish: External
pullSecret: <pull-secrets>
```

### Install operators on both the clusters

```yaml
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ocs-catalogsource
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/nigoyal/ocs-operator-index:latest
  displayName: OpenShift Data Foundation
  publisher: Red Hat
---
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-storage
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-storage
  namespace: openshift-storage
spec:
  targetNamespaces:
  - openshift-storage
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ocs-operator
  namespace: openshift-storage
spec:
  channel: alpha
  installPlanApproval: Automatic
  name: ocs-operator
  source: ocs-catalogsource
  sourceNamespace: openshift-marketplace
  startingCSV: ocs-operator.v4.11.0
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: noobaa-operator
  namespace: openshift-storage
spec:
  channel: alpha
  installPlanApproval: Automatic
  name: noobaa-operator
  source: ocs-catalogsource
  sourceNamespace: openshift-marketplace
  startingCSV: noobaa-operator.v5.9.0
```

### Add labels on the worker nodes on the provider cluster

```console
$ oc label nodes <NodeName> cluster.ocs.openshift.io/openshift-storage=''
```

### Create below storagecluster on the provider cluster

```yaml
apiVersion: ocs.openshift.io/v1
kind: StorageCluster
metadata:
  name: ocs-storagecluster
  namespace: openshift-storage
spec:
  allowRemoteStorageConsumers: true
  hostNetwork: true
  multiCloudGateway:
    reconcileStrategy: "ignore"
  storageDeviceSets:
  - count: 1
    dataPVCTemplate:
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 2Ti
        storageClassName: gp2
        volumeMode: Block
    name: default
    portable: true
    replica: 3
```

### Generate token using ocs-operator repo and create secret on provider cluster

```console
$ cd hack/ticketgen
$ openssl genrsa -out key.pem 4096
$ openssl rsa -in key.pem -out pubkey.pem -outform PEM -pubout
$ ./ticketgen.sh key.pem
$ oc create secret -n openshift-storage generic onboarding-ticket-key --from-file=key=pubkey.pem
```

Just do `./ticketgen.sh key.pem` for creating token for another consumers

### Create a storagecluster on consumer cluster

```yaml
apiVersion: ocs.openshift.io/v1
kind: StorageCluster
metadata:
 name: ocs-storagecluster
 namespace: openshift-storage
spec:
 externalStorage:
   enable: true
   storageProviderKind: ocs
   storageProviderEndpoint: <storageProviderEndpoint>
   onboardingTicket: <onboardingTicket>
   requestedCapacity: 1T
 multiCloudGateway:
   reconcileStrategy: "ignore"
```
