#!/usr/bin/env bash
set -e

# Setup python virtual environment
python3 -m venv /usr/local/bin/.ansible
source /usr/local/bin/.ansible/bin/activate

# Install python module dependancies
cat <<EOT | python3 -m pip install -r -
jmespath
kubernetes
EOT

# Create wrapper script for ansible-playbook
install -m 0755 <(cat <<"EOT"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.ansible/bin/activate
/usr/bin/ansible-playbook "$@"
EOT
) /usr/local/bin/ansible-playbook
