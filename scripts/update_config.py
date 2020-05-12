import yaml
import os

config_file_name = '~/.kube/config-demo'
context_name = os.environ.get('CLUSTER_NAME', 'demo')
user_name = context_name + "_admin"
stream = open(os.path.expanduser(config_file_name), 'r')

content = yaml.safe_load(stream.read())
content['clusters'][0]['name'] = context_name
content['contexts'][0]['name'] = context_name
content['contexts'][0]['context']['cluster'] = context_name
content['contexts'][0]['context']['user'] = user_name
content['current-context'] = context_name
content['users'][0]['name'] = user_name

file_to = open(os.path.expanduser(config_file_name), 'w')
yaml.dump(content, file_to, default_flow_style=False)
