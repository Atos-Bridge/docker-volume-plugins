Changelog
=========
## 2.0.10
* glusterfs: Change bind option "readonly" to "ro" for /etc/ssl mount to fix compatibility issue with containerd.io v1.7.24
* Bump Ubuntu version to 24.04
* Bump Go version to 1.23
* glusterfs: Bump GlusterFS client to v11.
* Add support for build.env file containing build arguments

## 2.0.4

* Fixed defunct process on GlusterFS plugin.
* Added S3Fs plugin.

## 1.3.1

* Used centos:7 as the base for glusterfs client (Fedora mirrors used by gluster/glusterfs-client get very slow)
* Switched all the plugins to "local" scope capability.

## 1.3.0

* NFS volume plugin added
* Fixed issue with volumes being lost on restart
* Dropped the "v" prefix

## v1.2.0

* CentOS Managed volume plugin added
* Fixed security issue with CIFS volume plugin

## v1.1.0

* CIFS volume plugin added
* Refactored code to move all the common parts into a separate package

## v1.0.0

* Initial release, just glusterfs
