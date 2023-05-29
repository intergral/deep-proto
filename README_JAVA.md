# Deep Proto
This is the generated code for the common APIs for DEEP. This is generated from the project [intergra/deep-proto](https://github.com/intergral/deep-proto).

# Usage
The usage of these packages differs between server and clients. Please see [GRPC docs](https://grpc.io/docs/languages/java/) for more guidance.

## Client
To use this as a client:

```java
import com.intergral.deep.proto.poll.v1.PollConfigGrpc;
import com.intergral.deep.proto.poll.v1.PollRequest;
import com.intergral.deep.proto.poll.v1.PollResponse;
import com.intergral.deep.proto.tracepoint.v1.Snapshot;
import com.intergral.deep.proto.tracepoint.v1.SnapshotResponse;
import com.intergral.deep.proto.tracepoint.v1.SnapshotServiceGrpc;

import io.grpc.ManagedChannel;
import io.grpc.netty.NettyChannelBuilder;


public void sendPoll() {
    // setup channel
    NettyChannelBuilder ncBuilder = NettyChannelBuilder.forAddress(serviceHost,servicePort)
    ManagedChannel channel = ncBuilder.build();
    // create client
    PollConfigGrpc.PollConfigBlockingStub blockingStub = PollConfigGrpc.newBlockingStub( channel );
    // send request
    PollResponse response = blockingStub.poll(PollRequest.newBuilder().build())
}

public void sendSnapshot() {
    // setup channel
    NettyChannelBuilder ncBuilder = NettyChannelBuilder.forAddress(serviceHost,servicePort)
    ManagedChannel channel = ncBuilder.build();
    // create client
    SnapshotServiceGrpc.SnapshotServiceStub snapshotServiceStub = SnapshotServiceGrpc.newStub.newBlockingStub( channel );
    // send request
    SnapshotResponse response = blockingStub.send(Snapshot.newBuilder().build())
}

```

## Server
To use this as a server:

```java
import com.intergral.deep.proto.tracepoint.v1.SnapshotServiceGrpc;
import com.intergral.deep.proto.tracepoint.v1.SnapshotResponse;
import com.intergral.deep.proto.poll.v1.PollResponse;

public class SnapshotService extends SnapshotServiceGrpc.SnapshotServiceImplBase {
    @Override
    public void send( final Snapshot request, final StreamObserver<SnapshotResponse> responseObserver )
    {
        // process incoming snapshot
        responseObserver.next(new SnapshotResponse());
    }
}

public class PollService extends PollConfigGrpc.PollConfigImplBase {
    @Override
    public void poll( final PollRequest request, final StreamObserver<PollResponse> responseObserver )
    {
        // process incoming poll
        responseObserver.next(new PollResponse());
    }
}

public void server() {
    // create server
    final Server build = ServerBuilder.forPort(30454)
            // register services
            .addService(new SnapshotService())
            .addService(new PollService())
            .build();
    // start server
    build.start();
    // keep alive
    build.awaitTermination();
}
```

# Documentation
The documentation for this project is available [here](https://intergral.github.io/deep-proto/common/).

# Licensing
This project is licensed as [AGPL-3.0-only](https://raw.githubusercontent.com/intergral/deep-proto/master/LICENSE).
