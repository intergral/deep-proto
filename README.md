[![PyPI](https://img.shields.io/pypi/v/deep-proto)](https://pypi.org/project/deep-proto/)
[![GitHub release (latest by date)](https://img.shields.io/github/v/tag/intergral/go-deep-proto?label=golang)](https://github.com/intergral/go-deep-proto)
[![Maven Central](https://img.shields.io/maven-central/v/com.intergral.deep/deep-proto)](https://central.sonatype.com/artifact/com.intergral.deep/deep-proto)
[![Release Proto](https://github.com/intergral/deep-proto/actions/workflows/release.yml/badge.svg)](https://github.com/intergral/deep-proto/actions/workflows/release.yml)

# Language Independent Interface Types For DEEP

The proto files can be consumed as GIT submodules or copied and built directly in the consumer project.

The compiled files are published to central repositories (Maven, ...).

## Generate gRPC Client Libraries

To generate the raw gRPC client libraries, use `make gen-${LANGUAGE}`. Currently supported languages are:

* python
* golang
* java

# Releasing

To release this we use GitHub Actions when a new release is tagged via GitHub.

# Licensing
See [LICENSING](LICENSING.md)

# Documentation
The docs are auto generated from the protobuf. They are then hosted on github pages [here](https://intergral.github.io/deep-proto/common/).
