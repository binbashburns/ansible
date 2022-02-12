# Ansible Notes
Ansible is an automation engine that allows for agentless system configuration and deployment over SSH.

## Housekeeping
- Once you have Ansible installed, if you need to, you can modify the /etc/ansible/ansible.cfg file: `vim /etc/ansible/ansible.cfg`
- You can see the default values for everything there
- By default, the inventory file used is /etc/ansible/hosts
- You can modify this with `sudo vim /etc/ansible/hosts`
- Go to the bottom, add the IP address of the target hosts, like so:
```
[managed-nodes]
10.1.2.138
10.1.2.24
```
- You could also give the host an "alias" to make it easier to manage, like this: `node1 ansible_host=10.1.2.138`
- You will also need to create the `ansible` user on all instances: `sudo useradd ansible`
- You can verify the `ansible` user was created with `getent passwd`
- **NOTE**: The `ansible` user should be created by default at runtime if you're using the Terraform lab environment.
- SSH to the **managed node(s)**
- On the **managed node(s)**, create a password for the `ansible` user with `sudo passwd ansible`
- The reason we set up the password is because we will have to log in with it in order to create a pre-shared key
- We don't need a password on the control node because we  will be logging into it with SSH
- Go back to the **Control Node**
- Switch to the `ansible` user with `sudo su - ansible`
- Now run the SSH keygen `ssh-keygen`. Just hit Enter and accept defaults for purpose of the lab. 
- You need to copy the public key to the **managed node(s)** in order for pre-shared key authentication to work.
- **NOTE**: If you are using the Terraform lab environment, on the **managed node(s)** you must first edit the SSH config. `sudo vi /etc/ssh/sshd_config`, change `PasswordAuthentication` to `Yes`, `sudo systemctl restart sshd`
- You can do this easily with `ssh-copy-id 10.1.2.138`
- Here is where it will prompt you for the password you set earlier. Type **yes** and enter the password
- It will tell you it has successfully been added, and recommend you try logging on remotely. It will display the syntax to do so
