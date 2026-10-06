# feh

feh is a versatile and fast image viewer using imlib2, the premier image file handling library. feh has many features, from simple single file viewing, to multiple file modes using a slideshow or multiple windows. feh supports the creation of montages as index prints with many user-configurable options.

wikipedia.org/wiki/Feh_(image_viewer)

<img src="https://raw.githubusercontent.com/AppJail-makejails/feh/refs/heads/main/feh/feh.png" width="30%" height="auto" alt="feh logo">

## How to use this AppJail

For each new release, the AppJail can be obtained as an asset. [`sysutils/bin`](https://freshports.org/sysutils/bin) is a binary manager capable of downloading, installing, and updating, making it well-suited for our purposes.

```console
$ doas pkg install -y bin
```

Install the latest version of this AppJail by running the following command:

```console
$ mkdir -p ~/bin
$ bin install https://github.com/appjail-makejails/feh
```

Or update it if it is already installed:

```console
$ bin update feh.appjail
```

Assuming `~/bin` is in your `PATH`, you can run the AppJail simply by using the following command:

```console
$ feh.appjail
```

Remember that when running an AppJail in portable mode, you must install the key used to verify the binary:

```console
$ cat << "EOF" | doas x11appjail trust dtxdf@disroot.org -
untrusted comment: dtxdf@disroot.org (x11appjail) public key
RWSZbdqRaZVSgICvhui+nrVbXbWw25jyZx/3lhaPzSmVi1Pgvk2DAB1h
EOF
$ x11appjail trusted
KEY                                                                   COMMENT
37e1a7da5478a29ec3d38ecb14919b107beab67cc0de0b473b5b018f018e1ccb.pub  dtxdf@disroot.org (x11appjail) public key
```



### User Attributes

##### `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.jail.ephemeral`

Mark the jail as ephemeral. See `ephemeral` option in `appjail-quick(1)` for details.

Although the jail may be destroyed, its data is preserved in the user directory (see `${X11APPJAIL_USERDIR}` in `x11appjail-spec(5)`).

### System Attributes

##### `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.labels`

A space-separated list of label names.
##### `network.mode`

Network mode. Default is `none`.

There are three modes:

1. `virtualnet`: This option is recommended, as it provides isolation and allows a more fine-grained control. It's necessary to install and configure AppJail on the host, as specified in the "[Getting Started](https://appjail.readthedocs.io/en/latest/getting-started/)" guide.
2. `inherit`: This mode does not provide network isolation. From a networking perspective, it is exactly the same as running the application on the host.
3. `none`: Completely disable the network stack.
##### `oci.from`

Location of OCI image.
##### `oci.tag`

OCI image tag.
##### `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.labels.<label>`

The value of the label.
##### `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.oci.from`

Same as `oci.from`, but by application. It takes precedence when defined.
##### `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.oci.tag`

Same as `oci.tag`, but by application. It takes precedence when defined.
##### `users.${X11APPJAIL_UID}.perms`

A space-separated list of "permissions" granted to a specific user.

The implemented "permissions" are presented below:

* `enable_3d`
* `webcam`
* `usb`
* `sound`

For a description of any of them, consult `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.allow.<permission>` in the "[User Attributes](#user-attributes)" section.
##### `network.security-group.tables`

If `network.mode` is set to `virtualnet`, this attribute specifies a space-separated list of `pf(4)` tables to which the jail will be added using Security Group hooks.

If you are going to add additional labels related to Security Groups, do not include `security-group:1`, as this attribute already include it.

See also: https://github.com/DtxdF/AppJail/wiki/filter
##### `mount.system-fonts`

Read-only mounts the fonts system inside the jail, configure Fontconfig, and rebuild the font cache.
##### `network.virtualnet`

Specify the virtual network to be used when `network.mode` is set to `virtualnet`. If not specified, no virtual network is defined, so the default one is used.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
