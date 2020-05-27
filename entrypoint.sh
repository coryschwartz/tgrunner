echo git repo: "$GITREPO"
echo plan: "$PLAN"
echo testcase: "$TESTCASE"
echo instances: "$INSTANCES"
echo daemon: "$DAEMON"


/usr/local/bin/testground plan import --git --from "$GITREPO"
/usr/local/bin/testground --endpoint "$DAEMON" run single           \
	                             --builder docker:go            \
				     --runner cluster:k8s           \
				     --instances "$INSTANCES"       \
				     --plan "$PLAN"                 \
				     --testcase "$TESTCASE"         \
				     --build-cfg registry_type=aws  \
				     --build-cfg push_registry=true \
				     --build-cfg go_proxy_mode=direct
