{% from 'titan/settings.sls' import titan with context %}

include:
  - titan.rexster

# create install root
{{ titan.root_dir }}:
  file:
    - directory
    - makedirs: true

# download and extract the titan archive into the proper location
install_titan:
  cmd:
    - run
    - name: 'wget -q {{ titan.url }} && unzip -qq `basename {{ titan.url }}` && mv `basename {{ titan.url }} .zip`/* . && rm -rf `basename {{ titan.url}} .zip`'
    - unless: 'test -d conf'
    - cwd: {{ titan.root_dir }}
    - require:
      - file: {{ titan.root_dir }}

configure_titan:
  file:
    - managed
    - name: '{{ titan.root_dir }}/conf/stackdio-titan.properties'
    - template: jinja
    - source: salt://titan/conf/titan.properties
    - require:
      - cmd: install_titan
