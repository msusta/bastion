sshd-pkg:
  pkg.installed:
    - name: task-ssh-server

sshd-conf:
  augeas.change:
    - context: /files/etc/ssh/sshd_config
    - changes:
      - set PermitRootLogin without-password
      - set X11Forwarding no
    - require:
      - pkg: sshd-pkg
      - pkg: augeas-pkg

sshd-service:
  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - watch:
      - augeas: sshd-conf
    - require:
      - pkg: sshd-pkg
      - augeas: sshd-conf

istram-usr:
  user.present:
    - name: istram
    - gid_from_name: True
    - groups:
      - sudo
    - remove_groups: False

istram-key:
  ssh_auth.present:
    - user: istram
    - enc: ssh-rsa
    - name: AAAAB3NzaC1yc2EAAAADAQABAAABAQCq/qCEbIz+WfLxY2gNHNOmZR987TAH2jIbaQ4m6XHkg1TAN7F0sjqM1Eh+w07LkLnWaWPi4L+DDdcT31xLNpKNPHMqACdGwsQC8hh63XrH0g//Zse+Uxb+JXbpOwlxO0bxOkDwScMgmdwHhvyKPNxfG7LywLqsN6pgSqzhVnZpO8UauJ1fNrPik0vKmIJxWAmPQGBpVaavjw7JYYujv3puOan24J8HrpHcM5z2cgf8piitGbX/Ud0Cs6kZE+9vnoGsxoApSDBwv+kLxFfSKFm1cl+wyNAHJLhvMwKPu1DjKTivUMMYNyyvFJ9lsMTBJ/u1iAKTU00xiNFlRN5sY+9L
    - require:
      - user: istram-usr

root-key:
  ssh_auth.present:
    - user: root
    - enc: ssh-rsa
    - name: AAAAB3NzaC1yc2EAAAADAQABAAABAQCq/qCEbIz+WfLxY2gNHNOmZR987TAH2jIbaQ4m6XHkg1TAN7F0sjqM1Eh+w07LkLnWaWPi4L+DDdcT31xLNpKNPHMqACdGwsQC8hh63XrH0g//Zse+Uxb+JXbpOwlxO0bxOkDwScMgmdwHhvyKPNxfG7LywLqsN6pgSqzhVnZpO8UauJ1fNrPik0vKmIJxWAmPQGBpVaavjw7JYYujv3puOan24J8HrpHcM5z2cgf8piitGbX/Ud0Cs6kZE+9vnoGsxoApSDBwv+kLxFfSKFm1cl+wyNAHJLhvMwKPu1DjKTivUMMYNyyvFJ9lsMTBJ/u1iAKTU00xiNFlRN5sY+9L
