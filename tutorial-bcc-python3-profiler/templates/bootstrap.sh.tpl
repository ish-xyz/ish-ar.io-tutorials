#!/bin/bash
# Bootstrap instance GCP

useradd -m -s /bin/bash ${ssh_user}
echo "${ssh_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${ssh_user}

mkdir -p /home/${ssh_user}/${demo_dir}
mkdir -p /home/${ssh_user}/.ssh/

cat <<EOF > /home/${ssh_user}/.ssh/authorized_keys
${public_key}
EOF

chown -R ${ssh_user}:${ssh_user} /home/${ssh_user}