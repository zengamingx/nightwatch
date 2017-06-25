docker pull zengamingx/end2end-testing
if docker run --ipc=host --rm -i zengamingx/nightwatch; then
	RESULT=SUCCESS
    COLOR=good

    curl -XPOST -H "Content-type: application/json" -d '{
      "routing_key": "d6fc9726ce4b4dec869529331f4d68de",
      "event_action": "resolve",
      "dedup_key": "e2e-tests"
    }' 'https://events.pagerduty.com/v2/enqueue'
else
	RESULT=FAILURE
    COLOR=danger
    PAYLOAD="{\"channel\": \"#build\", \"username\": \"Ivan Zenski\", \"attachments\": [{\"text\": \"Build <${BUILD_URL}|${JOB_NAME} #${BUILD_NUMBER}> finished with result: $RESULT - @dev check it out ASAP!\", \"color\": \"${COLOR}\"}]}"
	curl -s -X POST --data-urlencode "payload=$PAYLOAD" 'https://hooks.slack.com/services/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'
    curl -XPOST -H "Content-type: application/json" -d '{
      "routing_key": "d6fc9726ce4b4dec869529331f4d68de",
      "event_action": "trigger",
      "dedup_key": "e2e-tests",
      "payload": {
        "summary": "e2e failed",
        "source": "e2e",
        "severity": "warning"
      }
    }' 'https://events.pagerduty.com/v2/enqueue'
    exit 1
fi
