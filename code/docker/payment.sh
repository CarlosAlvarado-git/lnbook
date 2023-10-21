function run-in-node () {
	docker exec "$1" /bin/bash -c "${@:2}"
}

echo "Get 10k sats invoice from Dina"
dina_invoice=$(run-in-node Dina "cli addinvoice 10 | jq -r .payment_request")
echo "- Dina invoice: "
echo ${dina_invoice}