openvpn-pkg:
  pkg.installed:
    - name: openvpn

openvpn-conf:
  file.managed:
    - name: /etc/openvpn/server.conf
    - source: salt://files/openvpn-server.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn-pkg
