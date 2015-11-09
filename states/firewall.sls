firewall-pkg:
  pkg.installed:
    - name: firewalld

firewall-sshd:
  file.managed:
    - name: /etc/firewalld/direct.xml
    - source: salt://files/firewalld-direct.xml
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: firewall-pkg

# 2015.8
#firewalld-conf:
#  firewalld.present:
#    - name: public
#    - default: True
#    - ports:
#      - 22/tcp
#      - 25/tcp

firewall-svc:
  service.running:
    - name: firewalld
    - enable: True
    - reload: True
    - watch:
      - file: firewall-sshd
    - require:
      - pkg: firewall-pkg
      - file: firewall-sshd
