# Ansible Basics
## About
This is just a bunch of Ansible snippets and notes, mostly for personal reference.</br>
Nothing serious, just taking some notes as a result of having gone through Ansible courses on ACloudGuru.</br>
If you're interested in checking out the courses for yourself, feel free to check it out, along with ACGs other courses at the link below!</br>

## Contents
This repo contains the following objects:
- **playbooks**: A directory containing sample Ansible playbooks
- **terraform**: A directory containing Terraform code that spins up an AWS lab environment (view next section)
- **.gitignore**: Git Ignore file. If you use Git to clone the repo, it ensures your Terraform config files created at runtime are not pushed to Github at `git push`
- **NOTES.md**: The main notes file that contains a walkthrough of how to use the Terraform lab environment and some random code snippets
- **README.md**: The README.md file. What you're reading now.

## AWS Lab Environment (Terraform Required)
- There is an optional lab environment you can spin up in the `terraform` directory of this repository 
- There is a Network Diagram in the **terraform/** directory as well that shows how the lab environment is configured
- You must have Terraform installed and be logged in via AWS CLI
- From the command line:
```
cd terraform/
terraform init
terraform apply --auto-approve
```
- The public IP address of the jump box in the public subnet will be displayed as an output once everything is complete.
- This machine is only accessible via SSH. A key is created for you in Secrets Manager at runtime.
- Once the lab has spun up, copy the IP address and access the machine via SSH using the key in Secrets Manager
- You are now logged into the Ansible Control Node. 
- From the control node you can access the EC2 instance in the private subnet to run playbooks

## References used:
- Ansible Quick Start:   https://acloudguru.com/course/ansible-quick-start
