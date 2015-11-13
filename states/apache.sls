apache-pkg:
  pkg.installed:
    - pkgs:
      - apache2
      - libapache2-mod-security2

apache-ssl-key:
  file.managed:
    - name: /etc/ssl/private/istram_cz_key.pem
    - contents_pillar: bastion:apache:key
    - mode: 0600

apache-ssl-cert:
  file.managed:
    - name: /etc/ssl/certs/istram_cz.pem
    - source: salt://files/istram_cz.pem
    - mode: 644
    - user: root
    - group: root

apache-security:
  augeas.change:
    - context: /files/etc/apache2/conf-enabled/security.conf
    - changes:
      - set ServerTokens Prod

apache-svc:
  service.running:
    - name apache2
    - enable: True
    - reload: True
    - watch:
      - augeas: apache-security
    - require:
      - pkg: apache-pkg
