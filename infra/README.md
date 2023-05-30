
## Infrastructure Provisioning 
This is the steps to provision infrastructure for application deployment using Terraform in an AWS environment.

### Prerequisites

- #### Terraform Installation:
  - Download the Terraform binary (https://www.terraform.io/downloads.html) 
  - Add the downloaded binary to the system's PATH and Confirm the version of Terraform installed.
  ```shell
  $ terraform version
  ```

- #### Configure AWS Credentials:
  ```shell
  $ aws configure
  AWS Access Key ID [None]:
  AWS Secret Access Key [None]:
  Default region name [None]:
  Default output format [None]:
  ```


### Steps
1. #### Set variables
    - Set the variables in `variables.tf` file or create a file named `terraform.tfvars` to override variables.
   
2. #### Initialize Terraform
   ```shell
   $ terraform init
   ```

3. #### Execute Terraform
   - Review the execution plan before proceeding with the provisioning.
   ```shell
   $ terraform plan
   ```
   - Once you have reviewed the plan, execute the provisioning.
   ```shell
   $ terraform apply
   ```

4. #### Verify Deployment
   - After completing the execution, verify and utilize the deployed infrastructure.

5. #### Clean Up Resources
   - If the resources are no longer required, you should delete the provisioned resources. 
   ```shell
   $ terraform destroy
   ```
