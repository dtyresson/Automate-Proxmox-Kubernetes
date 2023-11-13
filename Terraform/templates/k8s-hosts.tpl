[master]
${k8s_master}

[node]
${k8s_workers}

[k8s_cluster:children]
master
node