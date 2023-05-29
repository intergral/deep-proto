# Deep Proto
This is the generated code for the common APIs for DEEP. This is generated from the project [intergra/deep-proto](https://github.com/intergral/deep-proto).

# Usage
The usage of these packages differs between server and clients. Please see [GRPC docs](https://grpc.io/docs/languages/python/) for more guidance.

## Client
To use this as a client:

```python
import grpc
from deepproto.proto.tracepoint.v1.tracepoint_pb2 import Snapshot


def pollServer()
    # setup the connection channel
    channel = grpc.secure_channel("deep:43315", grpc.ssl_channel_credentials())
    # create stub service
    stub = PollConfigStub(channel)
    # create request
    request = PollRequest()
    # send request and await response
    response = stub.poll(request)


def sendSnapshot()
    # setup the connection channel
    channel = grpc.secure_channel("deep:43315", grpc.ssl_channel_credentials())
    # create stub service
    stub = SnapshotServiceStub(channel)
    # create grpc snapshot message
    snapshot = Snapshot()
    # send snapshot, and await response
    response = stub.send(snapshot)
```

## Server
To use this as a server:

```python
import deepproto
import grpc

from deepproto.proto.poll.v1.poll_pb2 import PollResponse, ResponseType
from deepproto.proto.poll.v1.poll_pb2_grpc import PollConfigServicer
from deepproto.proto.tracepoint.v1.tracepoint_pb2 import TracePointConfig, SnapshotResponse
from deepproto.proto.tracepoint.v1.tracepoint_pb2_grpc import SnapshotServiceServicer

def serve():
    # configure GRPC
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

    # register the services
    deepproto.proto.poll.v1.poll_pb2_grpc.add_PollConfigServicer_to_server(PollServicer(), server)
    deepproto.proto.tracepoint.v1.tracepoint_pb2_grpc.add_SnapshotServiceServicer_to_server(SnapshotServicer(), server)
    
    # start the server
    server.add_insecure_port('[::]:43315')
    server.start()
    server.wait_for_termination()


class SnapshotServicer(SnapshotServiceServicer):
    def send(self, request, context):
        # Code to process a new snapshot
        return SnapshotResponse()


class PollServicer(PollConfigServicer):
    def poll(self, request, context):
        # code to process a poll request
        return PollResponse()
```

# Documentation
The documentation for this project is available [here](https://intergral.github.io/deep-proto/common/).

# Licensing
This project is licensed as [AGPL-3.0-only](https://raw.githubusercontent.com/intergral/deep-proto/master/LICENSE).
