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

openvpn-cert:
  file.managed:
    - name: /etc/openvpn/server-cert.pem
    - source: salt://files/openvpn-cert.pem
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn-pkg

openvpn-key:
  file.managed:
    - name: /etc/openvpn/server-key.pem
    - contents_pillar: bastion:openvpn:key
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: openvpn-pkg

