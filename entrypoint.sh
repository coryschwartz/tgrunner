echo git repo: "$GITREPO"
echo plan: "$PLAN"
echo testcase: "$TESTCASE"
echo instances: "$INSTANCES"
echo daemon: "$DAEMON"


# Scale up
/usr/local/bin/kops export kubecfg --name "$NAME"
/usr/local/bin/kops replace -f large.yaml --force
/usr/local/bin/kops kops update cluster --yes --name "$NAME"
/usr/local/bin/kops validate cluster --wait 600s


# run testground
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

# Scale down
/usr/local/bin/kops replace -f small.yaml --force
/usr/local/bin/kops update cluster --yes --name "$NAME"

# re-apply ingress
/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml
/usr/local/bin/kubectl apply -f ingress.yaml
