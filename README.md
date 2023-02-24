[![use-action](https://github.com/otaviof/setup-tekton/actions/workflows/use-action.yaml/badge.svg)](https://github.com/otaviof/setup-tekton/actions/workflows/use-action.yaml)

`setup-tekton` GitHub Actions
-----------------------------

Action to rollout [Tekton Pipelines][githubTektonPipeline], [CLI (`tkn`)][githubTektonCLI] and a [Container-Registry][containerRegistry] instance, setting up the environment for testing using these components.

# GitHub Action Usage

Example usage below with inputs using default values:

```yaml
---
jobs:
  setup-tekton:
    steps:
      # using KinD to provide the Kubernetes instance and kubectl
      - uses: helm/kind-action@main
        with:
          cluster_name: kind

      # setting up Tekton Pipelines, CLI and additional components...
      - uses: otaviof/setup-tekton@main
          tekton_version: v0.45.0
          cli_version: v0.29.1
          setup_registry: "true"
          patch_etc_hosts: "true"
```

The action uses the current Kubernetes instance available ([KinD][sigsKinD] for example), thus requires `kubectl` on the `${PATH}`.

## Inputs

| Input               | Required | Description                                     |
|:--------------------|:--------:|:------------------------------------------------|
| `tekton_version`    | `false`  | Target Tekton Pipeline version                  |
| `cli_version`       | `false`  | Target Tekton CLI version                       |
| `setup_registry`    | `false`  | Rollout a Container-Registry (v2)               |
| `patch_etc_hosts`   | `false`  | Add Container-Registry hostname to `/etc/hosts` |

# Components

## Tekton Pipelines

[Tekton Pipelines][githubTektonPipeline] is deployed on the namespace `tekton-pipelines` and the involved deployments are followed until completion, so the setup process waits until the instances are available and in case of error the workflow is interrupted.

## CLI (`tkn`)

[Tekton CLI][githubTektonCLI] is installed on `/usr/local/bin` directory and uses the same Kubernetes context than `kubectl`.

## Container-Registry

A [Container-Registry][containerRegistry] instance is deployed on the `registry` namespace using the same rollout approach than Tekton Pipelines.

The registry is available on port `32222` and uses the Kubernetes internal service hostname, `registry.registry.svc.cluster.local`, which means the fully qualified container images (plus tag) will look like the example below:

```text
registry.registry.svc.cluster.local:32222/namespace/project:tag
```

The registry does not require authentication, uses HTTP protocol, is available outside of the Kubernetes instance as well. The Action Input `patch_etc_hosts` makes the registry hostname resolve to `127.0.0.1` and the service exposes the port `32222` as a `hostPort` too.

# Scripts

Alternatively, you can run the scripts directly to rollout Tekton Pipelines and the other components, the recommended approach is using a `.env` file with the required [inputs](./inputs.sh).

```bash
cat >.env <<EOS
export INPUT_TEKTON_VERSION="v0.42.0"
export INPUT_CLI_VERSION="v0.29.1"
EOS

source .env
```

There are shell plugins to automatically load the `.env` file, once the required environment variables are set you can invoke each script individually:

```bash
./install-tekton.sh
./install-registry.sh
sudo ./install-cli.sh
```

The script name reflects the component deployed and they are idempotent, you can run them more than once without side effects.

[sigsKinD]: https://kind.sigs.k8s.io
[githubTektonCLI]: https://github.com/tektoncd/cli
[githubTektonPipeline]: https://github.com/tektoncd/pipeline
[containerRegistry]: https://docs.docker.com/registry/spec/api/