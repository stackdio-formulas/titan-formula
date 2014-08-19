{% set cassandra_seeds = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cassandra.seed', 'grains.items', 'compound').items() -%}
{% set zkquorum = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.zookeeper', 'grains.items', 'compound').items() -%}
{% set hbase_master = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.hbase.master', 'grains.items', 'compound').values()[0] -%}

{% set titan_root = salt['pillar.get']('titan:install_dir', '/mnt/titan') %}
{% set titan_url = salt['pillar.get']('titan:archive', 'http://s3.thinkaurelius.com/downloads/titan/titan-0.5.0-hadoop2.zip') %}

{% set titan = {
  'root_dir': titan_root,
  'url': titan_url
} %}

{% if cassandra_seeds %}
{% do titan.update({
  'storage_backend': 'cassandra',
  'storage_hostname': cassandra_seeds[0].fqdn  
}) %}
{% elif zkquorum and hbase_master %}
{% do titan.update({
  'storage_backend': 'hbase',
  'storage.hostname': "{% for host, items in zkquorum %}{{ items['fqdn'] }}{% if not loop.last %},{% endif %}{% endfor %}"
}) %}
{% elif hbase_master %}
{% do titan.update({
  'storage_backend': 'hbase',
  'storage_hostname': hbase_master.fqdn
}) %}
{% endif %}
