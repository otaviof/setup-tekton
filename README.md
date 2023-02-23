`setup-tekton`
--------------

# Usage

```yaml
---
jobs:
  setup-tekton:
    steps:
      # using KinD to provide the Kubernetes instance and kubectl
      - uses: helm/kind-action@v1.4.0
	  # setting up Tekton and auxiliary components...
      - uses: otaviof/setup-tekton@main
```

## Inputs

```yaml
jobs:
  use-action:
    steps:
      - uses: otaviof/setup-tekton@main
        with:
          tekton_version: v0.45.0
          cli_version: v0.29.1
          setup_registry: "true"
          registry_hostname: registry.registry.svc.cluster.local
          patch_etc_hosts: "true"
```