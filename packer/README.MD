## 🤠 HOWDY 🤠

So couple of notes to get going. 

1. I would recommend downloading the iso manually. The provider seems to have issues/odd behavior when downloading an iso. 
2. Most sensitive values, I hope I got out :). I use the env() function with packer. See [packer.env.example](https://github.com/benjamin-lykins/homelab/blob/main/packer/packer.env.example) for the variables will accept env values. 

```bash
export PROXMOX_URL=https://8.8.8.8/api2/json
export PROXMOX_PASSWORD=password
export PROXMOX_ROOT_PASSWORD=password
export PROXMOX_USER_PASSWORD=password
```

### When Running

In my example, I run three different builds. Typically with Packer, I would do a base build, then build upon the base build. I was lazy and didn't do that. These all will take a fresh iso and build a unique image. 

For my most basic image --

```bash
packer build -var-file=packer/varfiles/base.pkrvars.hcl  -force packer/builds/base/.
```

For my server/control plane style image ---

This will build an image with Vault + Nomad + Consul. 

Consul + Vault are WIP.

```bash
packer build -var-file=packer/varfiles/server.pkrvars.hcl  -force packer/builds/base/.
```

For my client style image ---

This will build an image with Consul + Nomad and run workloads. 

Set up with docker, podman, exec2, and java capabilities. 

```bash
packer build -var-file=packer/varfiles/server.pkrvars.hcl  -force packer/builds/base/.
```
