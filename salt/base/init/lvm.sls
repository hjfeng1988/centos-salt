{% if 'vdb' in grains['disks'] %}
  {% set disk = 'vdb' %}
{% elif 'xvdb' in grains['SSDs'] %}
  {% set disk = 'xvdb' %}
{% else %}
  {% set disk = '' %}
{% endif %}

{% if disk %}
/dev/{{ disk }}:
  lvm.pv_present

vg_data:
  lvm.vg_present:
    - devices: /dev/{{ disk }}
    - require:
      - lvm: /dev/{{ disk }}

lv_data:
  lvm.lv_present:
    - vgname: vg_data
    - extents: 100%FREE
    - require:
      - lvm: vg_data

{% if grains['osfinger'] == 'CentOS Linux-7' %}
/dev/vg_data/lv_data:
  blockdev.formatted:
    - fs_type: xfs
    - require:
      - lvm: lv_data

/data:
  mount.mounted:
    - device: /dev/vg_data/lv_data
    - fstype: xfs
    - mkmnt: True
    - opts:
      - defaults
    - require:
      - blockdev: /dev/vg_data/lv_data
{% endif %}
{% endif %}
