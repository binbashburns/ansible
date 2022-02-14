# Ansible Notes
Ansible is an automation engine that allows for agentless system configuration and deployment over SSH.

## Debugging
If you use the Terraform lab, here are some important notes on debugging:
- If something in the user data doesn't install at boot time, check these logs: `sudo cat /var/log/cloud-init.log`

## Housekeeping
- Once you have Ansible installed, if you need to, you can modify the /etc/ansible/ansible.cfg file: `vim /etc/ansible/ansible.cfg`
- You can see the default values for everything there
- By default, the inventory file used is `/etc/ansible/hosts`
- You can modify this on the **Control Node** with `sudo vim /etc/ansible/hosts`
- Go to the bottom, add the IP address of the target hosts, like so:
```
[nodes]
10.1.2.138
10.1.2.24
```
- You could also give the host an "alias" to make it easier to manage, like this: `node1 ansible_host=10.1.2.138`
- You will also need to create the `ansible` user on all instances: `sudo useradd ansible`
- You can verify the `ansible` user was created with `getent passwd`
- **NOTE**: If you're using the Terraform lab environment, the `ansible` user is already created at runtime.
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
- Let's imagine you want to review documentation for the **ansible.builtin.apt** module. Use: </br>
`ansible-doc -s apt`

## Ansible Modes
### Ansible Ad-hoc
- Comparable to **bash commands**
- Example: Create a user
- One-off things that you do not expect to repeat
- Useful when you're learning a module and you don't know how it works
- Ad-hoc commands are ran using the `ansible` command. Example: </br>
`ansible nodes -m setup | less`
- **NOTE**: The `setup` module gathers information about the hosts specified. It is very verbose, so the `less` command helps us to see a little at a time.
- More information on the `setup` module can be found here: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html 
- Another example of an ad-hoc command is to test the reachability of a remote node:</br>
`ansible nodes -m ping`
- Let's say you wanted to install Apache Web Server. Try:</br>
`ansible nodes -m yum -a "name=httpd state=latest"`
- If you try the above command, you will get an error message telling you that you need to run the command as a superuser. For that, we'll add the `-b` flag (more information on the `--become` or `-b` flag can be found at https://docs.ansible.com/ansible/latest/user_guide/become.html). So the command will be:</br>
`ansible nodes -b -m yum -a "name=httpd state=latest"`
- The above command will only install Apache though. Let's make sure we start the httpd service (like `systemctl start httpd`, but the Ansible way!):</br>
`ansible nodes -b -m service -a "name=httpd state=started"`
- You can verify that **httpd** is running by going to the **managed node(s)** and running `sudo systemctl status httpd`. You should see something like:
```
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: **active (running)** since Sat 2022-02-12 21:06:09 UTC; 2min 10s ago ...
```
- If you were to run the `ansible nodes -b -m service -a "name=httpd state=started"` command again, you'll see basically the same image you saw before, only this time the text will be **green** as opposed to **orange**. 
- It will also have `"changed": false` toward the top. This is because Ansible understands the concept of **state**
- Plays, or specific ad-hoc commands, can be ran against the same target over and over again, with no consequence or whether or not it will create issues. An exception to this would be shell commands, which could escape that **idempotent** concept that we want to focus in on.

### Ansible Playbook
- Comparable to **bash scripts**
- Playbooks are the primary means for Ansible to perform tasks
- Playbooks are written in YAML
- Each element within the playbook is called a **play**
- Each **play** must contain a list of hosts and at least one **task**
- Each **task** has a name and module
- **NOTE**: Watch your spacing! Indentation can mess up your playbook.
- Playbooks are ran using the `ansible-playbook` command. 
- You can create individual inventory files as opposed to using the default inventory file. Example:</br>
`vim inventory`, then insert the following:
```
[webservers]
web1 ansible_host=10.1.2.188
web2 ansible_host=10.1.2.78
```
- Now, let's create a Ansible playbook, starting with `vim webbootstrap.yml`, then inputting the following:
```
--- # Bootstrap Webservers
- hosts: webservers
  become: yes
  tasks:
  - name: install httpd
    yum: 
      name: httpd
      state: latest
  - name: create index.html file
    file:
      name: /var/www/html/index.html
      state: touch
  - name: add web content
    lineinfile:
      line: "here is some text"
      path: /var/www/html/index.html
  - name: start httpd
    service:
      name: httpd
      state: started
```
- Save and close, then issue the following command:</br>
`ansible-playbook -i inventory webbootstrap.yml`
- You should now be able to validate that the httpd server is running with the following command:</br>
`curl 10.1.2.188:80/index.html`

## Ansible Variables
- A variable is really just a placeholder for data.
- Variables can be scoped by group, host, or within a playbook
- Variable names should be letters, numbers, and underscores. They should always start with a letter.
- Variables may be passed in via command line using the `--extra-vars`, the `-e` flag, or defined within a playbook
CLI Example:
```
ansible-playbook service.yml -e \
"target_hosts=localhost \
target_service=httpd";
```
- It is good practice to wrap variable names or statements containing variable names in weak quotes:</br>
`hosts: "{{ my_host_var }}"`
- Let's try changing this on our `webbootstrap.yml` playbook. 
Before:
```
...
  - name: install httpd
    yum:
      name: httpd
      state: latest
  - name: create index.html file
...
  - name: start httpd
    service:
      name: httpd
      state: started
```

After:
```
...
  - name: install httpd
    yum:
      name: "{{ target_service }}"
      state: latest
  - name: create index.html file
...
- name: start httpd
    service:
      name: "{{ target_service }}"
      state: started
```
- We then go to the command line and type the following:</br>
`ansible-playbook -i inventory webbootstrap.yml -e "target_service=httpd"`

## Ansible Facts
- Various properties about a given remote system
- The `setup` module can retrieve facts
- The filter parameter takes regex to allow you to prune fact output
- Facts are gathered by default in the Ansible Playbook execution
- The keyword `gather_facts` may be set in the playbook to change fact-gathering behavior
- It is possible to print Ansible facts in files using variables
- Facts may be filtered using the setup module `ad-hoc` by passing a value for the filter parameter
- The `ansible` command output may be directed to a file using the `--tree outputfile` flag which may be helpful when working with facts.
- It is possible to use `{{ ansible_facts }}` for conditional plays based on facts.
- Let's try this out on `web1` in the `inventory` file: </br>
`ansible -i inventory web1 -m setup`
- This provides a huge amount of information. What if we just want a subset of this information? </br>
`ansible -i inventory web1 -m setup -a filter=*ipv4*`
- It gives you a much smaller subset of information. Let's try again with another subset: </br>
`ansible -i inventory web1 -m setup -a filter=*hostname*`
- This information can also be used in your plays. Let's edit `webbootstrap.yml` once more.
- Before:
```
...
  - name: add web content
    lineinfile:
      line: "here is some text"
      path: /var/www/html/index.html
...
```
- After:
```
...
  - name: add web content
    lineinfile:
      line: "{{ ansible_hostname }}"
      path: /var/www/html/index.html
...
```
- The `"{{ ansible_hostname }}"` variable is one that you don't have to define, because it's defined by default when the playbook runs.
- Lets say you want to suppress gathering facts for some reason. You can do this by adding the `gather_facts: no` line in your playbook at the top.
- Before: 
```
--- # Bootstrap Webservers
- hosts: webservers
  become: yes
  tasks:
...
```
- After:
```
--- # Bootstrap Webservers
- hosts: webservers
  become: yes
  gather_facts: no
  tasks:
...
```

## Ansible Troubleshooting and Debugging
The `debug` module may be used to help troubleshoot plays:
- Use to print detailed information about in-progress plays
- Handy for troubleshooting

`debug` takes two primary parameters that are mutually exclusive:
- `msg`: A message that is printed to `stdout`
- `var`: A variable whose content is printed to `stdout`

Example:
```
- debug:
  msg: "System {{ inventory_hostname }} has uuid {{ ansible_product_uuid }}"
```
The `register` module is used to store task output. Several attributes are available:
- `return code`
- `stderr`
- `stdout`

The following play will store the results of the shell module in a variable name `motd_contents`: 
```
- hosts: all
  tasks:
   - shell: cat /etc/motd
     register: motd_contents
```

## Ansible Handler
- A mechanism that allows an action to be flagged for execution when a task performs a change
- By only executing certain tasks during a change, plays are more efficient
- A handler may be called using the `notify` keyword:
```
- name: template configuration file
  template:
    src: foo.conf
    dest: /etc/foo.conf
  notify:
  - restart memcached
```
No matter how many times a handler is flagged in a play, it only runs **once** during a play's final phase. </br>
`notify` will only flag a handler if a task block makes changes. </br>
If no changes happen, a handler is not flagged, and it not ran </br>
A handler may be defined similarly to tasks: 
```
handlers:
  - name: restart memcached
    service:
      name: memcached
      state: restarted
    listen: "restart cache services"
   