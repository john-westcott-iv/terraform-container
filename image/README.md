# Build Instructions into CRC:

docker login -u $(oc whoami) -p $(oc whoami -t) $(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
IMAGE_REGISTRY=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker build -t ${IMAGE_REGISTRY}/tower-terraform-demo/terraform-executor:latest .
docker push ${IMAGE_REGISTRY}/tower-terraform-demo/terraform-executor:latest

