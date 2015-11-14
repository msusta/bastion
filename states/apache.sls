apache-pkg:
  pkg.installed:
    - pkgs:
      - apache2
      - libapache2-mod-security2

apache-mod-ssl:
  apache_module.enable:
    - name: ssl

apache-mod-headers:
  apache_module.enable:
    - name: headers

apache-ssl-key:
  file.managed:
    - name: /etc/ssl/private/istram_cz_key.pem
    - contents_pillar: bastion:apache:key
    - mode: 0600

apache-ssl-cert:
  file.managed:
    - name: /etc/ssl/certs/istram_cz_chain.pem
    - source: salt://files/istram_cz_chain.pem
    - mode: 644

apache-ssl-ca-cert:
  file.managed:
    - name: /etc/ssl/certs/rapidssl_root_ca.pem
    - source: salt://files/rapidssl_ca.pem
    - mode: 644

apache-ssl-conf:
  file.managed:
    - name: /etc/apache2/mods-available/ssl.conf
    - source: salt://files/apache-ssl.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: apache-ssl-key
      - file: apache-ssl-cert
      - file: apache-ssl-ca-cert
      - apache_module: apache-mod-headers

apache-security:
  augeas.change:
    - context: /files/etc/apache2/conf-available/security.conf
    - changes:
      - set ServerTokens Prod
      - set ServerSignature Off
    - require:
      - pkg: apache-pkg

apache-svc:
  service.running:
    - name: apache2
    - enable: True
    - reload: True
    - watch:
      - augeas: apache-security
      - file: apache-ssl-conf
      - file: apache-ssl-key
      - file: apache-ssl-cert
      - file: apache-ssl-ca-cert
    - require:
      - pkg: apache-pkg
      - apache_module: apache-mod-ssl
      - file: apache-ssl-conf
