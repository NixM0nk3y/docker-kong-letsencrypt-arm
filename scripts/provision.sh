#!/bin/bash
set +e
export BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh

bold "Validating Environment..."
echo ""

enforce_arg "CONTACT_EMAIL" "The email address to register the LetsEncrypt certificate"
enforce_arg "FQDN" "The FQDN to generate certificates for" 
enforce_arg "KONG_GATEWAY" "Kong endpoint to send certs to" 

if [ ${MISSING_VAR:-0} -eq 1 ]; then
    bold "Missing Arguments!"
    exit
fi

$BASEDIR/generate_le.sh 

if [ $? -ne 0 ]; then
	bold "LetsEncrypt generation failed!"
fi

bold "All done!"
