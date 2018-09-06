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
	bold "LetsEncrypt generation failed!  Will generate a Self Signed certificate instead..."
	$BASEDIR/generate_self_signed.sh
fi

ls -l /www

bold "Uploading certificates to secret..."
curl -i -k -X POST ${KONG_GATEWAY}/certificates \
    -F "cert=@/www/${FQDN}.crt" \
    -F "key=@/www/${FQDN}.key" \
    -F "snis=${FQDN}"

bold "All done!"
