cd ./consul_config

kubectl apply -f ./proxy-defaults.yaml

# Ingress
curl --request PUT --data @ingress_ncloud.json http://default-consul-ui-283e2-6191148-4b2ed60c0fbe.kr.lb.naverncp.com:80/v1/config

# add DB Service
# curl --request PUT --data @ext_svc.json http://default-consul-ui-283e2-6191148-4b2ed60c0fbe.kr.lb.naverncp.com:80/v1/agent/service/register
# curl --request PUT --data @svc_link.json http://default-consul-ui-283e2-6191148-4b2ed60c0fbe.kr.lb.naverncp.com:80/v1/config

