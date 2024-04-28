# app-of-devops-apps

App of DevOps apps

- [app-of-devops-apps](#app-of-devops-apps)
  - [Deployment](#deployment)
  - [References](#references)

## Deployment

Deploying apps from the git repository

``` sh
git clone https://github.com/Hiroshi-N-S/app-of-devops-apps.git

sh app-of-devops-apps/bootstrap/init.sh
```

## References

- [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [Argo Workflows](https://argo-workflows.readthedocs.io/en/latest/)
  - [examples](https://github.com/argoproj/argo-workflows/tree/main/examples)
- [JupyterHub](https://z2jh.jupyter.org/en/latest/jupyterhub/index.html)
  - [Jupyter kernels](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels)
    - [IPyKernel: A Python Notebook Kernel for Jupyter](https://github.com/ipython/ipykernel)
    - [Deno: A Typescript Notebook Kernel for Jupyter](https://docs.deno.com/runtime/manual/tools/jupyter)
    - [GoNB: A Go Notebook Kernel for Jupyter](https://github.com/janpfeifer/gonb)
    - [EvCxR: A Rust Notebook Kernel for Jupyter](https://github.com/evcxr/evcxr/tree/main/evcxr_jupyter)
  - [Jupyter Server Proxy](https://jupyter-server-proxy.readthedocs.io/en/latest/)
    - Arbitrary external processes
      - [Coder/code-server](https://coder.com/docs/code-server/latest)
