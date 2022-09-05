#!/usr/bin/env bash

collaborator_config="/usr/local/collaborator/collaborator.config"
restart_collaborator_command="systemctl restart collaborator"
temp_file="/tmp/tempcerthookfile.json"


#check if this is the cleanup phase
if [[ -n "$CERTBOT_AUTH_OUTPUT" ]]
then
    $restart_collaborator_command
    exit
fi


challenge_record=$(cat <<-END
[
    {
        "label": "_acme-challenge",
        "record": "$CERTBOT_VALIDATION",
        "type": "TXT",
        "ttl": 10
    }
]
END
)

if [[ $(jq 'has("customDnsRecords")' $collaborator_config)  == "true" ]]
then
    if [[ $(jq '.customDnsRecords[] | select(.label == "_acme-challenge")' $collaborator_config)  ]]
        then
                echo "update challenge"
        jq --arg value "$CERTBOT_VALIDATION" '.customDnsRecords[] += {record:$value}' $collaborator_config > $temp_file
        else
        echo "array value"
        jq --argjson value "$challenge_record" '.customDnsRecords += $value' $collaborator_config > $temp_file
    fi
else
    echo "add new record"
    jq --argjson value "$challenge_record" '.+{customDnsRecords: $value}' $collaborator_config > $temp_file
fi

mv $temp_file $collaborator_config

$restart_collaborator_command
sleep 10
