# run-in-node: Run a command inside a docker container, using the bash shell
function run-in-node () {
	docker exec "$1" /bin/bash -c "${@:2}"
}

# wait-for-cmd: Run a command repeatedly until it completes/exits successfuly
function wait-for-cmd () {
		until "${@}" > /dev/null 2>&1
		do
			echo -n "."
			sleep 1
		done
		echo
}

# wait-for-node: Run a command repeatedly until it completes successfully, inside a container
# Combining wait-for-cmd and run-in-node
function wait-for-node () {
	wait-for-cmd run-in-node $1 "${@:2}"
}


alice_address="03e6eb60b9dce3495435781db1ed03b65ae1d7a18fd0122f3dde335ad226a92a43"
echo -n "Check Dina's route to Dina: "
run-in-node Dina "cli queryroutes --dest \"${alice_address}\" --amt 10000" > /dev/null 2>&1 \
&& {
	echo "Dina has a route to Alice "
} || {
	echo "Dina doesn't yet have a route to Alice"
	echo "Waiting for Dina graph sync. This may take a while..."
	wait-for-node Dina "cli describegraph | jq -e '.edges | select(length >= 1)'"
	echo "- Dina knows about 1 channel"
	wait-for-node Dina "cli describegraph | jq -e '.edges | select(length >= 2)'"
	echo "- Dina knows about 2 channels"
	wait-for-node Dina "cli describegraph | jq -e '.edges | select(length == 3)'"
	echo "- Dina knows about all 3 channels!"
	echo "Dina knows about all the channels"
}