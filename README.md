# Python safety check

This GitHub action is helpful to find known security vulnerabilities in your python application.

## Workflow integration

You can use this action in a workflow, to find known continuously security vulnerabilities. It is using the python package [safety](https://pypi.org/project/safety/), which is checking against the [Safety DB](https://github.com/pyupio/safety-db).

Example configuration:

```yaml
name: Python safety check

on:
  push:
    branches:
      - master

env:
  DEP_PATH: src/requirements.txt

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out master
        uses: actions/checkout@master

      - name: Security vulnerabilities scan
        uses: aufdenpunkt/python-safety-check@master
```

### ENV variables

To let the script know, where your `requirements.txt` file located is, you have to set the `DEP_PATH` environment variable. See the example above.

### Parameters

#### `safety_args`

This parameter is useful if you want to provide additional arguments to the command call. In the example below, I want to ignore a specific known issue. But you can pass any argument, which you can find in the [documentation](https://github.com/pyupio/safety#options).

_Example_:

```yaml
- name: Security vulnerabilities scan
  uses: aufdenpunkt/python-safety-check@master
  with:
    safety_args: '-i 35015'
```

#### `scan_requirements_file_only`

If you want to check only packages defined in your `requirements.txt` you are able to set this parameter to `'true'`.

_Example_:

```yaml
- name: Security vulnerabilities scan
  uses: aufdenpunkt/python-safety-check@master
  with:
    scan_requirements_file_only: 'true'
```

## Workflow customization

See full instructions for [Configuring and managing workflows](https://help.github.com/en/actions/configuring-and-managing-workflows).

For help editing the YAML file, see [Workflow syntax for GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions).
