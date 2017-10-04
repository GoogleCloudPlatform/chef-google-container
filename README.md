# Google Container Engine Chef Cookbook

This cookbook provides the built-in types and services for Chef to manage
Google Container Engine resources, as native Chef types.

## Requirements

### Platforms

#### Supported Operating Systems

This cookbook was tested on the following operating systems:

* RedHat 6, 7
* CentOS 6, 7
* Debian 7, 8
* Ubuntu 12.04, 14.04, 16.04, 16.10
* SLES 11-sp4, 12-sp2
* openSUSE 13
* Windows Server 2008 R2, 2012 R2, 2012 R2 Core, 2016 R2, 2016 R2 Core

## Example

```ruby
gauth_credential 'mycred' do
  action :serviceaccount
  path ENV['CRED_PATH'] # e.g. '/path/to/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/cloud-platform'
  ]
end

gcontainer_cluster 'test-cluster' do
  action :create
  zone 'us-central1-a'
  project 'google.com:graphite-playground'
  credential 'mycred'
end

gcontainer_node_pool 'web-servers' do
  action :create
  initial_node_count 4
  cluster 'test-cluster'
  zone 'us-central1-a'
  project 'google.com:graphite-playground'
  credential 'mycred'
end
```

## Credentials

All Google Cloud Platform cookbooks use an unified authentication mechanism,
provided by the `google-gauth` cookbook. Don't worry, it is automatically
installed when you install this module.

### Example

```ruby
gauth_credential 'mycred' do
  action :serviceaccount
  path ENV['CRED_PATH'] # e.g. '/path/to/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/cloud-platform'
  ]
end

```

For complete details of the authentication cookbook, visit the
[google-gauth][] cookbook documentation.

## Resources

* [`gcontainer_cluster`](#gcontainer_cluster) -
    A Google Container Engine cluster.
* [`gcontainer_node_pool`](#gcontainer_node_pool) -
    NodePool contains the name and configuration for a cluster's node pool.
    Node pools are a set of nodes (i.e. VM's), with a common configuration
    and
    specification, under the control of the cluster master. They may have a
    set of Kubernetes labels applied to them, which may be used to
    reference
    them during pod scheduling. They may also be resized up or down, to
    accommodate the workload.


### gcontainer_cluster
A Google Container Engine cluster.

#### Example

```ruby
gcontainer_cluster "mycluster-#{ENV['cluster_id']}" do
  action :create
  initial_node_count 2
  master_auth(
    username: 'cluster_admin',
    password: 'my-secret-password'
  )
  node_config(
    machine_type: 'n1-standard-4', # we want 4-cores for our cluster
    disk_size_gb: 500              # ... and a lot of disk space
  )
  zone 'us-central1-a'
  project 'google.com:graphite-playground'
  credential 'mycred'
end

```

#### Reference

```ruby
gcontainer_cluster 'id-for-resource' do
  addons_config           {
    horizontal_pod_autoscaling {
      disabled boolean,
    },
    http_load_balancing        {
      disabled boolean,
    },
  }
  cluster_ipv4_cidr       string
  create_time             time
  current_master_version  string
  current_node_count      integer
  current_node_version    string
  description             string
  endpoint                string
  expire_time             time
  initial_cluster_version string
  initial_node_count      integer
  location                [
    string,
    ...
  ]
  logging_service         'logging.googleapis.com' or 'none'
  master_auth             {
    client_certificate     string,
    client_key             string,
    cluster_ca_certificate string,
    password               string,
    username               string,
  }
  monitoring_service      'monitoring.googleapis.com' or 'none'
  name                    string
  network                 string
  node_config             {
    disk_size_gb    integer,
    image_type      string,
    labels          namevalues,
    local_ssd_count integer,
    machine_type    string,
    metadata        namevalues,
    oauth_scopes    [
      string,
      ...
    ],
    preemptible     boolean,
    service_account string,
    tags            [
      string,
      ...
    ],
  }
  node_ipv4_cidr_size     integer
  services_ipv4_cidr      string
  subnetwork              string
  zone                    string
  project                 string
  credential              reference to gauth_credential
end
```

#### Actions

* `create` -
  Converges the `gcontainer_cluster` resource into the final
  state described within the block. If the resource does not exist, Chef will
  attempt to create it.
* `delete` -
  Ensures the `gcontainer_cluster` resource is not present.
  If the resource already exists Chef will attempt to delete it.

#### Properties

* `name` -
  The name of this cluster. The name must be unique within this project
  and zone, and can be up to 40 characters with the following
  restrictions:
  * Lowercase letters, numbers, and hyphens only.
  * Must start with a letter.
  * Must end with a number or a letter.

* `description` -
  An optional description of this cluster.

* `initial_node_count` -
  Required. The number of nodes to create in this cluster. You must ensure
  that
  your Compute Engine resource quota is sufficient for this number of
  instances. You must also have available firewall and routes quota. For
  requests, this field should only be used in lieu of a "nodePool"
  object, since this configuration (along with the "nodeConfig") will be
  used to create a "NodePool" object with an auto-generated name. Do not
  use this and a nodePool at the same time.

* `node_config` -
  Parameters used in creating the cluster's nodes.
  For requests, this field should only be used in lieu of a "nodePool"
  object, since this configuration (along with the "initialNodeCount")
  will be used to create a "NodePool" object with an auto-generated
  name. Do not use this and a nodePool at the same time. For responses,
  this field will be populated with the node configuration of the first
  node pool. If unspecified, the defaults are used.

* `node_config/machine_type`
  The name of a Google Compute Engine machine type (e.g.
  n1-standard-1).  If unspecified, the default machine type is
  n1-standard-1.

* `node_config/disk_size_gb`
  Size of the disk attached to each node, specified in GB. The
  smallest allowed disk size is 10GB. If unspecified, the default
  disk size is 100GB.

* `node_config/oauth_scopes`
  The set of Google API scopes to be made available on all of the
  node VMs under the "default" service account.
  The following scopes are recommended, but not required, and by
  default are not included:
  * https://www.googleapis.com/auth/compute is required for mounting
  persistent storage on your nodes.
  * https://www.googleapis.com/auth/devstorage.read_only is required
  for communicating with gcr.io (the Google Container Registry).
  If unspecified, no scopes are added, unless Cloud Logging or Cloud
  Monitoring are enabled, in which case their required scopes will
  be added.

* `node_config/service_account`
  The Google Cloud Platform Service Account to be used by the node
  VMs.  If no Service Account is specified, the "default" service
  account is used.

* `node_config/metadata`
  The metadata key/value pairs assigned to instances in the cluster.
  Keys must conform to the regexp [a-zA-Z0-9-_]+ and be less than
  128 bytes in length. These are reflected as part of a URL in the
  metadata server. Additionally, to avoid ambiguity, keys must not
  conflict with any other metadata keys for the project or be one of
  the four reserved keys: "instance-template", "kube-env",
  "startup-script", and "user-data"
  Values are free-form strings, and only have meaning as interpreted
  by the image running in the instance. The only restriction placed
  on them is that each value's size must be less than or equal to 32
  KB.
  The total size of all keys and values must be less than 512 KB.
  An object containing a list of "key": value pairs.
  Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.

* `node_config/image_type`
  The image type to use for this node.  Note that for a given image
  type, the latest version of it will be used.

* `node_config/labels`
  The map of Kubernetes labels (key/value pairs) to be applied to
  each node. These will added in addition to any default label(s)
  that Kubernetes may apply to the node. In case of conflict in
  label keys, the applied set may differ depending on the Kubernetes
  version -- it's best to assume the behavior is undefined and
  conflicts should be avoided. For more information, including usage
  and the valid values, see:
  http://kubernetes.io/v1.1/docs/user-guide/labels.html
  An object containing a list of "key": value pairs.
  Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.

* `node_config/local_ssd_count`
  The number of local SSD disks to be attached to the node.
  The limit for this value is dependant upon the maximum number of
  disks available on a machine per zone. See:
  https://cloud.google.com/compute/docs/disks/
  local-ssd#local_ssd_limits
  for more information.

* `node_config/tags`
  The list of instance tags applied to all nodes. Tags are used to
  identify valid sources or targets for network firewalls and are
  specified by the client during cluster or node pool creation. Each
  tag within the list must comply with RFC1035.

* `node_config/preemptible`
  Whether the nodes are created as preemptible VM instances. See:
  https://cloud.google.com/compute/docs/instances/preemptible for
  more inforamtion about preemptible VM instances.

* `master_auth` -
  The authentication information for accessing the master endpoint.

* `master_auth/username`
  The username to use for HTTP basic authentication to the master
  endpoint.

* `master_auth/password`
  The password to use for HTTP basic authentication to the master
  endpoint. Because the master endpoint is open to the Internet, you
  should create a strong password.

* `master_auth/cluster_ca_certificate`
  Output only. Base64-encoded public certificate that is the root of trust for
  the cluster.

* `master_auth/client_certificate`
  Output only. Base64-encoded public certificate used by clients to
  authenticate
  to the cluster endpoint.

* `master_auth/client_key`
  Output only. Base64-encoded private key used by clients to authenticate to
  the
  cluster endpoint.

* `logging_service` -
  The logging service the cluster should use to write logs. Currently
  available options:
  * logging.googleapis.com - the Google Cloud Logging service.
  * none - no logs will be exported from the cluster.
  if left as an empty string,logging.googleapis.com will be used.

* `monitoring_service` -
  The monitoring service the cluster should use to write metrics.
  Currently available options:
  * monitoring.googleapis.com - the Google Cloud Monitoring service.
  * none - no metrics will be exported from the cluster.
  if left as an empty string, monitoring.googleapis.com will be used.

* `network` -
  The name of the Google Compute Engine network to which the cluster is
  connected. If left unspecified, the default network will be used.
  * Tip: To ensure it exists and it is operations, configure the network
  using 'gcompute_network' resource.

* `cluster_ipv4_cidr` -
  The IP address range of the container pods in this cluster, in CIDR
  notation (e.g. 10.96.0.0/14). Leave blank to have one automatically
  chosen or specify a /14 block in 10.0.0.0/8.

* `addons_config` -
  Configurations for the various addons available to run in the cluster.

* `addons_config/http_load_balancing`
  Configuration for the HTTP (L7) load balancing controller addon,
  which makes it easy to set up HTTP load balancers for services in
  a cluster.

* `addons_config/http_load_balancing/disabled`
  Whether the HTTP Load Balancing controller is enabled in the
  cluster. When enabled, it runs a small pod in the cluster that
  manages the load balancers.

* `addons_config/horizontal_pod_autoscaling`
  Configuration for the horizontal pod autoscaling feature, which
  increases or decreases the number of replica pods a replication
  controller has based on the resource usage of the existing pods.

* `addons_config/horizontal_pod_autoscaling/disabled`
  Whether the Horizontal Pod Autoscaling feature is enabled in
  the cluster. When enabled, it ensures that a Heapster pod is
  running in the cluster, which is also used by the Cloud
  Monitoring service.

* `subnetwork` -
  The name of the Google Compute Engine subnetwork to which the cluster
  is connected.

* `location` -
  The list of Google Compute Engine locations in which the cluster's
  nodes should be located.

* `endpoint` -
  Output only. The IP address of this cluster's master endpoint.
  The endpoint can be accessed from the internet at
  https://username:password@endpoint/
  See the masterAuth property of this resource for username and password
  information.

* `initial_cluster_version` -
  Output only. The software version of the master endpoint and kubelets used
  in the
  cluster when it was first created. The version can be upgraded over
  time.

* `current_master_version` -
  Output only. The current software version of the master endpoint.

* `current_node_version` -
  Output only. The current version of the node software components. If they
  are
  currently at multiple versions because they're in the process of being
  upgraded, this reflects the minimum version of all nodes.

* `create_time` -
  Output only. The time the cluster was created, in RFC3339 text format.

* `node_ipv4_cidr_size` -
  Output only. The size of the address space on each node for hosting
  containers.
  This is provisioned from within the container_ipv4_cidr range.

* `services_ipv4_cidr` -
  Output only. The IP address range of the Kubernetes services in this
  cluster, in
  CIDR notation (e.g. 1.2.3.4/29). Service addresses are typically put
  in the last /16 from the container CIDR.

* `current_node_count` -
  Output only. The number of nodes currently in the cluster.

* `expire_time` -
  Output only. The time the cluster will be automatically deleted in RFC3339
  text
  format.

* `zone` -
  Required. The zone where the cluster is deployed

#### Label
Set the `c_label` property when attempting to set primary key
of this object. The primary key will always be referred to by the initials of
the resource followed by "_label"

### gcontainer_node_pool
NodePool contains the name and configuration for a cluster's node pool.
Node pools are a set of nodes (i.e. VM's), with a common configuration and
specification, under the control of the cluster master. They may have a
set of Kubernetes labels applied to them, which may be used to reference
them during pod scheduling. They may also be resized up or down, to
accommodate the workload.


#### Example

```ruby
# Tip: Have environment variable 'cluster-id' set.
# Tip: Insert a gcontainer cluster with name mycluster-${cluster_id}
gcontainer_node_pool 'web-servers' do
  action :create
  initial_node_count 4
  cluster "mycluster-#{ENV['cluster_id']}"
  zone 'us-central1-a'
  project 'google.com:graphite-playground'
  credential 'mycred'
end

```

#### Reference

```ruby
gcontainer_node_pool 'id-for-resource' do
  autoscaling        {
    enabled        boolean,
    max_node_count integer,
    min_node_count integer,
  }
  cluster            reference to gcontainer_cluster
  config             {
    disk_size_gb    integer,
    image_type      string,
    labels          namevalues,
    local_ssd_count integer,
    machine_type    string,
    metadata        namevalues,
    oauth_scopes    [
      string,
      ...
    ],
    preemptible     boolean,
    service_account string,
    tags            [
      string,
      ...
    ],
  }
  initial_node_count integer
  management         {
    auto_repair     boolean,
    auto_upgrade    boolean,
    upgrade_options {
      auto_upgrade_start_time time,
      description             string,
    },
  }
  name               string
  version            string
  zone               string
  project            string
  credential         reference to gauth_credential
end
```

#### Actions

* `create` -
  Converges the `gcontainer_node_pool` resource into the final
  state described within the block. If the resource does not exist, Chef will
  attempt to create it.
* `delete` -
  Ensures the `gcontainer_node_pool` resource is not present.
  If the resource already exists Chef will attempt to delete it.

#### Properties

* `name` -
  The name of the node pool.

* `config` -
  The node configuration of the pool.

* `config/machine_type`
  The name of a Google Compute Engine machine type (e.g.
  n1-standard-1).  If unspecified, the default machine type is
  n1-standard-1.

* `config/disk_size_gb`
  Size of the disk attached to each node, specified in GB. The
  smallest allowed disk size is 10GB. If unspecified, the default
  disk size is 100GB.

* `config/oauth_scopes`
  The set of Google API scopes to be made available on all of the
  node VMs under the "default" service account.
  The following scopes are recommended, but not required, and by
  default are not included:
  * https://www.googleapis.com/auth/compute is required for mounting
  persistent storage on your nodes.
  * https://www.googleapis.com/auth/devstorage.read_only is required
  for communicating with gcr.io (the Google Container Registry).
  If unspecified, no scopes are added, unless Cloud Logging or Cloud
  Monitoring are enabled, in which case their required scopes will
  be added.

* `config/service_account`
  The Google Cloud Platform Service Account to be used by the node
  VMs.  If no Service Account is specified, the "default" service
  account is used.

* `config/metadata`
  The metadata key/value pairs assigned to instances in the cluster.
  Keys must conform to the regexp [a-zA-Z0-9-_]+ and be less than
  128 bytes in length. These are reflected as part of a URL in the
  metadata server. Additionally, to avoid ambiguity, keys must not
  conflict with any other metadata keys for the project or be one of
  the four reserved keys: "instance-template", "kube-env",
  "startup-script", and "user-data"
  Values are free-form strings, and only have meaning as interpreted
  by the image running in the instance. The only restriction placed
  on them is that each value's size must be less than or equal to 32
  KB.
  The total size of all keys and values must be less than 512 KB.
  An object containing a list of "key": value pairs.
  Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.

* `config/image_type`
  The image type to use for this node.  Note that for a given image
  type, the latest version of it will be used.

* `config/labels`
  The map of Kubernetes labels (key/value pairs) to be applied to
  each node. These will added in addition to any default label(s)
  that Kubernetes may apply to the node. In case of conflict in
  label keys, the applied set may differ depending on the Kubernetes
  version -- it's best to assume the behavior is undefined and
  conflicts should be avoided. For more information, including usage
  and the valid values, see:
  http://kubernetes.io/v1.1/docs/user-guide/labels.html
  An object containing a list of "key": value pairs.
  Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.

* `config/local_ssd_count`
  The number of local SSD disks to be attached to the node.
  The limit for this value is dependant upon the maximum number of
  disks available on a machine per zone. See:
  https://cloud.google.com/compute/docs/disks/
  local-ssd#local_ssd_limits
  for more information.

* `config/tags`
  The list of instance tags applied to all nodes. Tags are used to
  identify valid sources or targets for network firewalls and are
  specified by the client during cluster or node pool creation. Each
  tag within the list must comply with RFC1035.

* `config/preemptible`
  Whether the nodes are created as preemptible VM instances. See:
  https://cloud.google.com/compute/docs/instances/preemptible for
  more inforamtion about preemptible VM instances.

* `initial_node_count` -
  Required. The initial node count for the pool. You must ensure that your
  Compute
  Engine resource quota is sufficient for this number of instances. You
  must also have available firewall and routes quota.

* `version` -
  Output only. The version of the Kubernetes of this node.

* `autoscaling` -
  Autoscaler configuration for this NodePool. Autoscaler is enabled only
  if a valid configuration is present.

* `autoscaling/enabled`
  Is autoscaling enabled for this node pool.

* `autoscaling/min_node_count`
  Minimum number of nodes in the NodePool. Must be >= 1 and <=
  maxNodeCount.

* `autoscaling/max_node_count`
  Maximum number of nodes in the NodePool. Must be >= minNodeCount.
  There has to enough quota to scale up the cluster.

* `management` -
  Management configuration for this NodePool.

* `management/auto_upgrade`
  A flag that specifies whether node auto-upgrade is enabled for the
  node pool. If enabled, node auto-upgrade helps keep the nodes in
  your node pool up to date with the latest release version of
  Kubernetes.

* `management/auto_repair`
  A flag that specifies whether the node auto-repair is enabled for
  the node pool. If enabled, the nodes in this node pool will be
  monitored and, if they fail health checks too many times, an
  automatic repair action will be triggered.

* `management/upgrade_options`
  Specifies the Auto Upgrade knobs for the node pool.

* `management/upgrade_options/auto_upgrade_start_time`
  Output only. This field is set when upgrades are about to commence with the
  approximate start time for the upgrades, in RFC3339 text
  format.

* `management/upgrade_options/description`
  Output only. This field is set when upgrades are about to commence with the
  description of the upgrade.

* `cluster` -
  Required. A reference to Cluster resource

* `zone` -
  Required. The zone where the node pool is deployed

#### Label
Set the `np_label` property when attempting to set primary key
of this object. The primary key will always be referred to by the initials of
the resource followed by "_label"

[google-gauth]: https://supermarket.chef.io/cookbooks/google-gauth
