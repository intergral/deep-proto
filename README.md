![PyPI](https://img.shields.io/pypi/v/deep-proto)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/intergral/go-deep-proto?label=golang)


# Language Independent Interface Types For DEEP

The proto files can be consumed as GIT submodules or copied and built directly in the consumer project.

The compiled files are published to central repositories (Maven, ...).

## Generate gRPC Client Libraries

To generate the raw gRPC client libraries, use `make gen-${LANGUAGE}`. Currently supported languages are:

* python
* golang
