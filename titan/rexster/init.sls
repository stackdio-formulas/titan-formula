{% from 'titan/settings.sls' import titan with context %}

include:
  - titan

configure_rexster:
  file:
    - managed
    - name: '{{ titan.root_dir }}/conf/stackdio-rexster.properties'
    - template: jinja
    - source: salt://titan/conf/rexster.properties
    - require:
      - cmd: install_titan

start_rexster:
  cmd:
    - run
    - name: 'nohup bin/rexster.sh -s -c {{ titan.root_dir }}/conf/stackdio-rexster.properties &> rexster.log &'
    - cwd: {{ titan.root_dir }}
    - require:
      - file: configure_rexster
