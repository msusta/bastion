sumo-collector-conf:
  file.managed:
    - name: /etc/sumo.conf
    - template: jinja
    - source: salt://files/sumo.conf

sumo-collector-svc:
  service.running:
    - name: collector
    - reload: False
    - enable: True
    - require:
      - file: sumo-collector-conf
    - watch:
      - file: sumo-collector-conf
