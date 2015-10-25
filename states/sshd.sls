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
