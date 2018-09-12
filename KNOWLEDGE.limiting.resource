#------------------------------------------ #
#              LIMIT RESOURCE               #
#------------------------------------------ #
- Use cgroup tech from Linux kernel
Ex: 
docker run -d --name test-limit-resource \
--memory 200m \
--memory-swap 1G \
--cpu-shares 1024 \
gcr.io/kuar-demo/kuard-amd64:
