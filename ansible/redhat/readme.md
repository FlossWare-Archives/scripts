# Red Hat Based Provisioning
The [Ansible playbooks] (http://docs.ansible.com/ansible/playbooks_variables.html) found here are solely for configuring Red Hat based systems.

## emailServer.yml
This playbook will setup an email server, installing and configuring:
* [dovecot] (http://www.dovecot.org) for pop3.
* [postfix] (http://www.postfix.org) for sending/receiving email.

### Variables

#### Postfix
The variables denoted below are the same name/values one uses to configure postfix.  However, those are preceeded with *postfix_*.

##### Optional
* postfix_myhostname
* postfix_mydomain

##### Required
* postfix_myorigin
* postfix_proxy_interfaces
* postfix_relayhost

## emailClient.yml
This playbook will install:
* [alpine] (http://www.washington.edu/alpine) as an email client.
* [fetchmail] (http://www.fetchmail.info) to retrieve emails and drop them locally.
* hunspell and hunspell English