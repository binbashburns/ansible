# Ansible Notes
Ansible is an automation engine that allows for agentless system configuration and deployment over SSH.

## Debugging
If you use the Terraform lab, here are some important notes on debugging:
- If something in the user data doesn't install at boot time, check these logs: `sudo cat /var/log/cloud-init.log`

## Housekeeping
- Once you have Ansible installed, if you need to, you can modify the /etc/ansible/ansible.cfg file: `vim /etc/ansible/ansible.cfg`
- You can see the default values for everything there
- By default, the inventory file used is /etc/ansible/hosts
- You can modify this with `sudo vim /etc/ansible/hosts`
- Go to the bottom, add the IP address of the target hosts, like so:
```
[nodes]
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
- **NOTE**: If you are using the Terraform lab environment, on the **managed node(s)** you must first edit the SSH config. `sudo vi /etc/ssh/sshd_config`, change `PasswordAuthentication` to `Yes`, `sudo systemctl restart sshd`
- Go back to the **Control Node**
- Switch to the `ansible` user with `sudo su - ansible`
- Now run the SSH keygen `ssh-keygen`. Just hit Enter and accept defaults for purpose of the lab. 
- You need to copy the public key to the **managed node(s)** in order for pre-shared key authentication to work.
- You can do this easily with `ssh-copy-id 10.1.2.138`
- Here is where it will prompt you for the password you set earlier. Type **yes** and enter the password
- It will tell you it has successfully been added, and recommend you try logging on remotely. It will display the syntax to do so
- On the **managed node(s)**, run `sudo visudo`. This brings you to the sudoers file. It is where you can allow users to execute commands as root.
- Under `## Same thing without a password` block, type `ansible ALL=(ALL) NOPASSWD: ALL`. The block should now look like this:
```
## Same thing without a password
# %wheel        ALL=(ALL)       NOPASSWD: ALL
ansible         ALL=(ALL)       NOPASSWD: ALL
```
- Now any command ran by the `ansible` user will be ran as root.

## Ansible Docs
- It is important to know where to look for information from within Ansible docs. You need to know where to find good documentation, quickly.
- The best place to start, is https://docs.ansible.com
- The most important place is the Module Index: https://docs.ansible.com/ansible/latest/collections/index_module.html
- You can also use the `ansible-doc` command at the command line. 
- Let's imagine you want to review documentation for the **ansible.builtin.apt** module. Use `ansible-doc s ansible.builtin.apt`

## Ansible Modes
### Ansible Ad-hoc
- Comparable to **bash commands**
- Example: Create a user
- One-off things that you do not expect to repeat
- Useful when you're learning a module and you don't know how it works
- Ad-hoc commands are ran using the `ansible` command. Example: `ansible nodes -m setup | less`
- **NOTE**: The `setup` command gathers information about the hosts specified. It is very verbose, so the `less` command helps us to see a little at a time.
- More information on the `setup` module can be found here: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html 
- Another example of an ad-hoc command is `ansible nodes -m ping`, which just tests the reachability of a remote node.
- Let's say you wanted to install Apache Web Server. Try `ansible nodes -m yum -a "name=httpd state=latest"`
- If you try the above command, you will get an error message telling you that you need to run the command as a superuser. For that, we'll add the `-b` flag (more information on the `--become` or `-b` flag can be found at https://docs.ansible.com/ansible/latest/user_guide/become.html). So the command will be:
`ansible nodes -b -m yum -a "name=httpd state=latest"`

### Ansible Playbook
- Comparable to **bash scripts**
- Example 