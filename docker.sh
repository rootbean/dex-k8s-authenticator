VERSION=1.4.7
docker build -t ruber19/dex-k8s-authenticator-ccp:$VERSION .
docker push ruber19/dex-k8s-authenticator-ccp:$VERSION
