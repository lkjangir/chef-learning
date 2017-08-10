# vroozi-devqa Cookbook

TODO: This Cookbook includes below recipes to configure server for desired state. 
  - common  : installs common software
  - elasticsearch : install elasticsearch
  - java  : installs jdk
  - maven : installs maven
  - nodejs  : installs nodejs
  - randg : installs randg and its dependencies
  - solr  : installs solr 
  - start_services  : to start all the services 
  - tokumx  : installs tokumx
  - tomcat  : installs tomcat 
  - w_nginx : wrapper for nginx, this installs nginx and creates host cofigurations for all apps



## Requirements

TODO: AWS Cli


### Platforms

- Amazon linux

### Chef

- Chef 12.0 or later

### Cookbooks

- `toaster` - vroozi-devqa needs toaster to brown your bagel.

## Attributes

TODO: List your cookbook attributes here.

e.g.
### vroozi-devqa::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['vroozi-devqa']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### vroozi-devqa::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `vroozi-devqa` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[vroozi-devqa]"
  ]
}
```


e.g.
1. Fork the repository on Github
2. Upload this to Chef server
3. Add to runlist
4. Bootstrap instance to install this 


## License and Authors


Authors: TODO: Lokesh Jangir

