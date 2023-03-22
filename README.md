# Language Independent Interface Types For DEEP

The proto files can be consumed as GIT submodules or copied and built directly in the consumer project.

The compiled files are published to central repositories (Maven, ...).

See [contribution guidelines](CONTRIBUTING.md) if you would like to make any changes.

## Generate gRPC Client Libraries

To generate the raw gRPC client libraries, use `make gen-${LANGUAGE}`. Currently supported languages are:

* python
