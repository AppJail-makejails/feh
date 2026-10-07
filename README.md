# feh

feh is a versatile and fast image viewer using imlib2, the premier image file handling library. feh has many features, from simple single file viewing, to multiple file modes using a slideshow or multiple windows. feh supports the creation of montages as index prints with many user-configurable options.

wikipedia.org/wiki/Feh_(image_viewer)

<img src="https://raw.githubusercontent.com/AppJail-makejails/feh/refs/heads/main/feh/feh.png" width="30%" height="auto" alt="feh logo">

## How to use this AppJail

### General usage

You can obtain the AppJail from the releases section of this repository. However, to go beyond a simple download and be able to update it conveniently from the console, the simplest complementary tool for our purposes is [sysutils/bin](https://freshports.org/sysutils/bin), a binary manager:

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

A system-wide installation requires only root access; the key is not necessary. However, it is strongly recommended to verify the binary before installation, making it necessary to install the key anyway.

```console
$ x11appjail verify ~/bin/feh.appjail
Signature Verified
$ doas ~/bin/feh.appjail --install
$ x11appjail run feh
```

An AppJail creates the jail only if it does not already exist or if the AppJail detects a valid change in its checksum (e.g.: after an update). This means that updates to the OCI image used by the AppJail are only checked at the creation time. If you need to update the OCI image, simply destroy the jail:

```console
$ x11appjail destroy-jail feh
```

Once you run the AppJail again, the OCI image is pulled again only if it is newer than the one on your system.
### Examples

If you run this AppJail specifying an existing regular file on the host, it will be transferred internally via stdin to the `feh(1)` process:

```console
$ ~/bin/feh.appjail /path/to/file
```

The last argument is always used as the file. However, this AppJail handles the concept of a URL. For example, the equivalent of the previous command is as follows:

```console
$ ~/bin/feh.appjail file:///path/to/file
```

If you specify a URL using another scheme, this AppJail also detects it and uses it as-is. This means that, for example, you can open a remote image using a protocol supported by `feh(1)`:

```console
$ ~/bin/feh.appjail https://cdn.bootprint.space/mars/2.png
$ # Or if you have been installed this AppJail:
$ x11appjail run feh https://picsum.photos/200
```

A special form is `jail://`, which means the specified path resides within the jail.

```console
$ x11appjail transfer /path/to/myimage.jpg feh:myimage.jpg
$ ~/bin/feh.appjail jail://myimage.jpg
```


### Attributes
#### User Attributes

| Name | Description |
| --- | --- |
| `ephemeral` | Mark the jail as ephemeral. See `ephemeral` option in `appjail-quick(1)` for details.<br><br>Although the jail may be destroyed, its data is preserved in the user directory (see `${X11APPJAIL_USERDIR}` in `x11appjail-spec(5)`).<br>|

#### System Attributes

| Name | Description |
| --- | --- |
| `labels` | A space-separated list of label names.|
| `network-mode` | Network mode. Default is `none`.<br><br>There are three modes:<br><br>1. `virtualnet`: This option is recommended, as it provides isolation and allows a more fine-grained control. It's necessary to install and configure AppJail on the host, as specified in the "[Getting Started](https://appjail.readthedocs.io/en/latest/getting-started/)" guide.<br>2. `inherit`: This mode does not provide network isolation. From a networking perspective, it is exactly the same as running the application on the host.<br>3. `none`: Completely disable the network stack.<br>|
| `oci-from` | Location of OCI image.|
| `oci-tag` | OCI image tag.|
| `per-labels` | The value of the label.|
| `per-oci-from` | Same as `oci.from`, but by application. It takes precedence when defined.|
| `per-oci-tag` | Same as `oci.tag`, but by application. It takes precedence when defined.|
| `perms` | A space-separated list of "permissions" granted to a specific user.<br><br>The implemented "permissions" are presented below:<br><br>* `enable_3d`<br>* `webcam`<br>* `usb`<br>* `sound`<br><br>For a description of any of them, consult `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.allow.<permission>` in the "[User Attributes](#user-attributes)" section.<br>|
| `secgroup-tables` | If `network.mode` is set to `virtualnet`, this attribute specifies a space-separated list of `pf(4)` tables to which the jail will be added using Security Group hooks.<br><br>If you are going to add additional labels related to Security Groups, do not include `security-group:1`, as this attribute already include it.<br><br>See also: https://github.com/DtxdF/AppJail/wiki/filter<br>|
| `system-fonts` | Read-only mounts the fonts system inside the jail, configure Fontconfig, and rebuild the font cache.|
| `virtualnet` | Specify the virtual network to be used when `network.mode` is set to `virtualnet`. If not specified, no virtual network is defined, so the default one is used.|

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

## Notes

1. Since the last argument is used as the file path, `--start-at` will not work, because the mechanism actually used to transfer the file from the host to the jail is `-`, meaning standard input is employed.
2. The file is read with the privileges of the calling process; therefore, if that process lacks permission to read the file, a "Permission Denied" error will occur, just as it would with a regular program.
3. If the last argument is `--`, the arguments are passed as-is, without transferring any file via stdin.
