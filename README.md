The ansible-opsworks recipes are chef 'wrappers' for kicking off ansible playbooks from
opsworks.

Opsworks has 5 lifecycle events that run during different stages of
instance buildout (http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-events.html)

- setup
- configure
- deploy
- undeploy
- shutodwn
 
Each lifecycle event will run a corresponding playbook in
/home/ec2-user/ansbile on the remote instance (if it's present).

- setup.yml
- configure.yml
- deploy.yml
- undeploy.yml
- shutdown.yml

Opsworks default
(http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-json.html)
and custom
(http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks-json.html)
json is also passed to the ansible playbooks.

To access opsworks default json, reference {{ opsworks.xxxxx }} from jinja2.

If you'd like to pass custom json to your ansible templates, you must
use the 'ansible' key in your custom json definition.  

Note that 'environment' is a required field in the custom json.

```
{ 
  ansible: {
    environment: 'dev',
    region: 'us-east-1',
    foo: 'bar'
  }
}
```

Instances will be tagged with a role matching the name of the
layer that they're brought up in.
