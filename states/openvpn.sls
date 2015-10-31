openvpn-pkg:
  pkg.installed:
    - name: openvpn

bastion-ca-cert:
  file.managed:
    - name: /etc/openvpn/bastion-ca.pem
    - source: salt://files/bastion-ca.pem
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn-pkg

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

openvpn-dh:
  cmd.run:
    - name: 'openssl dhparam -out /etc/openvpn/dh2048.pem 2048'
    - unless: 'stat /etc/openvpn/dh2048.pem'

openvpn-service:
  service.running:
    - name: openvpn
    - enabled: True
    - reload: False
    - watch:
      - file: openvpn-conf
      - file: openvpn-cert
      - file: openvpn-key
      - cmd: openvpn-dh
    - require:
      - file: openvpn-conf
      - file: openvpn-cert
      - file: openvpn-key
      - cmd: openvpn-dh
