## dependency-params-bug

Reproducing a porter bug with passing parameters to dependent porter bundles.

From the porter CLI, installing the exec component individually works:

```bash
$ porter version
porter v0.23.0-beta.1-8-g2eb38e9 (2eb38e9)
$ porter install \
    --tag brandoconnor/cnab-exec-component:v0.3.0 \
    --param environment=qa # this defaults to dev within the bundle
installing cnab-exec-component...
executing install action from cnab-exec-component (bundle instance: cnab-exec-component)
Testing variable IO within dependency
{
  "action": "install",
  "environment": "qa",
  "somearg": "foo"
}
execution completed successfully!
```

When invoked inside a parent bundle, passing parameters to a child bundle doesn't
work, whether hardcoded as defaults within the parent bundle or given as parameters
from the parent bundle:

```bash
$ cd cnab-parent-component
# executing the bundle with environment=prod
$ porter install --param environment=prod
Executing dependency exec-child...
executing install action from cnab-exec-component (bundle instance: cnab-parent-component-exec-child)
Testing variable IO within dependency
{
  "action": "install",
  "environment": "dev",
  "somearg": "foo"
}
execution completed successfully!
installing cnab-parent-component...
executing install action from cnab-parent-component (bundle instance: cnab-parent-component)
Install Hello World
Hello World
execution completed successfully!
# hardcoding that parameter within the parent produces the same result.
# no args are being passed successfully.
# With --debug:
$ porter install --param environment=prod --debug
DEBUG name:    exec
DEBUG pkgDir: /Users/boconnor/.porter/mixins/exec
DEBUG file:
DEBUG stdin:

/Users/boconnor/.porter/mixins/exec/exec version --output json --debug
...

/Users/boconnor/.porter/mixins/terraform/terraform version --output json --debug
Resolved dependency exec-child to brandoconnor/cnab-exec-component:v0.3.0
Executing dependency exec-child...
installing bundle cnab-exec-component (/Users/boconnor/.porter/cache/d03e740ff2b3a9b8d7e4759eff839a85/cnab/bundle.json) as cnab-parent-component-exec-child
        params: [environment porter-debug somearg]
        creds: []
Resolved storage plugin to storage.porter.filesystem
/Users/boconnor/.porter/porter plugin run storage.porter.filesystem
executing install action from cnab-exec-component (bundle instance: cnab-parent-component-exec-child)
Testing variable IO within dependency
{
  "action": "install",
  "environment": "dev",
  "somearg": "foo"
}
execution completed successfully!
Resolved storage plugin to storage.porter.filesystem
/Users/boconnor/.porter/porter plugin run storage.porter.filesystem
Resolved storage plugin to storage.porter.filesystem
/Users/boconnor/.porter/porter plugin run storage.porter.filesystem
installing cnab-parent-component...
```

Hardcoding parameters within the parent doesn't work, passing parameters through
the parent doesn't work. The child bundle doesn't seem to receive any params and
successfully pass them as flags during invocation. Only defaults can be used.
