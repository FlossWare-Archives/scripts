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

## cobbler.yml
This playbook will setup cobbler, installing and configuring it.  *Please note:  Apache will also be installed.*

### Variables

#### /etc/cobbler/modules.conf
The variables defiend below correspond to the sections defined in the modules.conf file and are defaulte to the following values.  We are preceeding each variable to represent those sections with *cobbler_*.

* cobbler_authentication = *authn_configfile*
* cobbler_authorization = *authz_allowall*
* cobbler_dns = *manage_bind*
* cobbler_dhcp = *manage_isc*
* cobbler_tftpd = *manage_in_tftpd*

#### /etc/cobbler/users.digest
For the users.digest file,
* cobbler_htdigest_user - if defined assumes our htdigest user value.
* cobbler_htdigest_md5 - if defined assumes our htdigest MD5 value.