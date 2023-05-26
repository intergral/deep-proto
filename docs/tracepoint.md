# Protocol Documentation
<a name="top"></a>

## Table of Contents

- [deepproto/proto/tracepoint/v1/tracepoint.proto](#deepproto_proto_tracepoint_v1_tracepoint-proto)
    - [Snapshot](#deepproto-proto-tracepoint-v1-Snapshot)
    - [Snapshot.VarLookupEntry](#deepproto-proto-tracepoint-v1-Snapshot-VarLookupEntry)
    - [SnapshotResponse](#deepproto-proto-tracepoint-v1-SnapshotResponse)
    - [StackFrame](#deepproto-proto-tracepoint-v1-StackFrame)
    - [TracePointConfig](#deepproto-proto-tracepoint-v1-TracePointConfig)
    - [TracePointConfig.ArgsEntry](#deepproto-proto-tracepoint-v1-TracePointConfig-ArgsEntry)
    - [Variable](#deepproto-proto-tracepoint-v1-Variable)
    - [VariableID](#deepproto-proto-tracepoint-v1-VariableID)
    - [WatchResult](#deepproto-proto-tracepoint-v1-WatchResult)
  
    - [SnapshotService](#deepproto-proto-tracepoint-v1-SnapshotService)
  
- [Scalar Value Types](#scalar-value-types)



<a name="deepproto_proto_tracepoint_v1_tracepoint-proto"></a>
<p align="right"><a href="#top">Top</a></p>

## deepproto/proto/tracepoint/v1/tracepoint.proto



<a name="deepproto-proto-tracepoint-v1-Snapshot"></a>

### Snapshot



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ID | [bytes](#bytes) |  | the client generated ID for this snapshot |
| tracepoint | [TracePointConfig](#deepproto-proto-tracepoint-v1-TracePointConfig) |  | the config that was used to generate this snapshot (it could be deleted by the time we look at the data) |
| var_lookup | [Snapshot.VarLookupEntry](#deepproto-proto-tracepoint-v1-Snapshot-VarLookupEntry) | repeated | this is a flat list of all the collected variables for this snapshot, to reduce data size we dereference as much as we can |
| ts_nanos | [fixed64](#fixed64) |  | the time in nanos since 1970 when this snapshot was generated |
| frames | [StackFrame](#deepproto-proto-tracepoint-v1-StackFrame) | repeated | the active frames at the time the snapshot is generated |
| watches | [WatchResult](#deepproto-proto-tracepoint-v1-WatchResult) | repeated | the watches results |
| attributes | [deepproto.proto.common.v1.KeyValue](#deepproto-proto-common-v1-KeyValue) | repeated | the attributes for this snapshot (e.g file_name or line_no) |
| duration_nanos | [uint64](#uint64) |  | the time in nano seconds it took to collect the data |
| resource | [deepproto.proto.common.v1.KeyValue](#deepproto-proto-common-v1-KeyValue) | repeated | the resource for this snapshot (e.g service.name) |






<a name="deepproto-proto-tracepoint-v1-Snapshot-VarLookupEntry"></a>

### Snapshot.VarLookupEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [Variable](#deepproto-proto-tracepoint-v1-Variable) |  |  |






<a name="deepproto-proto-tracepoint-v1-SnapshotResponse"></a>

### SnapshotResponse







<a name="deepproto-proto-tracepoint-v1-StackFrame"></a>

### StackFrame



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| file_name | [string](#string) |  | This is the full path of the file where the line of code is paused. |
| method_name | [string](#string) |  | This is the method or function name that is being called. |
| line_number | [uint32](#uint32) |  | This is the line number where the program is paused. |
| class_name | [string](#string) | optional | The class name of where the function is defined |
| is_async | [bool](#bool) | optional | This indicates that the frame is an async frame |
| column_number | [uint32](#uint32) | optional | This is the column number for the line, primarily used in node. |
| transpiled_file_name | [string](#string) | optional | The name of the transpiled file. If we have mappings available we can map the file &#39;something.js&#39; to the original typescript. This will be the transpiled file name e.g. something.js |
| transpiled_line_number | [uint32](#uint32) | optional | The transpiled line number |
| transpiled_column_number | [uint32](#uint32) | optional | The transpiled column number |
| variables | [VariableID](#deepproto-proto-tracepoint-v1-VariableID) | repeated | This is the list of variables (using var ids) that are present at this point in the code. |
| app_frame | [bool](#bool) | optional | This indicates if the frame is from inside the app, or is from a library |
| native_frame | [bool](#bool) | optional | This indicates if the frame, from a native library (primarily used in Java) |






<a name="deepproto-proto-tracepoint-v1-TracePointConfig"></a>

### TracePointConfig
This is the config of a tracepoint that should be installed by the application agent.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ID | [string](#string) |  | The ID of the config |
| path | [string](#string) |  | The path for the file to install in |
| line_number | [uint32](#uint32) |  | the line number to install on |
| args | [TracePointConfig.ArgsEntry](#deepproto-proto-tracepoint-v1-TracePointConfig-ArgsEntry) | repeated | arbitrary key/kay of config values (this can contain conditions, logs, fire counts etc) |
| watches | [string](#string) | repeated | expressions to evaluate at the this point of the code |
| targeting | [deepproto.proto.common.v1.KeyValue](#deepproto-proto-common-v1-KeyValue) | repeated | the targeting config for this tracepoint |






<a name="deepproto-proto-tracepoint-v1-TracePointConfig-ArgsEntry"></a>

### TracePointConfig.ArgsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [string](#string) |  |  |






<a name="deepproto-proto-tracepoint-v1-Variable"></a>

### Variable



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| type | [string](#string) |  | the type of the variable (e.g string) |
| value | [string](#string) |  | the value of the variable as a string. All values are converted to string for simplicity. This can also result in the value being truncated if it is a very large string. Collection types should not be to stringed, instead a summary should be given as the value &#39;HashSet of size: 10&#39;. |
| hash | [string](#string) |  | This is the hash of the object, this is primarily of use in Java/Python, node does not really have global object ids, so this is less useful. However using the debugger apis we are exposed the object ID at the time of collection. This can change depending on the script location as well (e.g. the stack frame). We send this object ID hashed to obfuscate any data. For non object values (that do not have an object ID) we hash the value. |
| children | [VariableID](#deepproto-proto-tracepoint-v1-VariableID) | repeated | This is a list of children of this variable, using the var ids, requiring them to be looked up in the var lookup |
| truncated | [bool](#bool) | optional | true if the value has been truncated |






<a name="deepproto-proto-tracepoint-v1-VariableID"></a>

### VariableID
The


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ID | [string](#string) |  | the ID to use to look up in the snapshot &#39;var_lookup&#39; |
| name | [string](#string) |  | the name of the variable at the point this ID is referenced (this might be modified to better match source code) |
| modifiers | [string](#string) | repeated | the modifiers (private, static etc) at the point this ID is referenced |
| original_name | [string](#string) | optional | the unmodified name from the engine |






<a name="deepproto-proto-tracepoint-v1-WatchResult"></a>

### WatchResult



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| expression | [string](#string) |  | the expression executed to collect the data |
| good_result | [VariableID](#deepproto-proto-tracepoint-v1-VariableID) |  | the ID of the variable that represents the result |
| error_result | [string](#string) |  | this is to contain the error message generated if the watch expression fails |





 

 

 


<a name="deepproto-proto-tracepoint-v1-SnapshotService"></a>

### SnapshotService


| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| send | [Snapshot](#deepproto-proto-tracepoint-v1-Snapshot) | [SnapshotResponse](#deepproto-proto-tracepoint-v1-SnapshotResponse) |  |

 



## Scalar Value Types

| .proto Type | Notes | C++ | Java | Python | Go | C# | PHP | Ruby |
| ----------- | ----- | --- | ---- | ------ | -- | -- | --- | ---- |
| <a name="double" /> double |  | double | double | float | float64 | double | float | Float |
| <a name="float" /> float |  | float | float | float | float32 | float | float | Float |
| <a name="int32" /> int32 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="int64" /> int64 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="uint32" /> uint32 | Uses variable-length encoding. | uint32 | int | int/long | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="uint64" /> uint64 | Uses variable-length encoding. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum or Fixnum (as required) |
| <a name="sint32" /> sint32 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sint64" /> sint64 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="fixed32" /> fixed32 | Always four bytes. More efficient than uint32 if values are often greater than 2^28. | uint32 | int | int | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="fixed64" /> fixed64 | Always eight bytes. More efficient than uint64 if values are often greater than 2^56. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum |
| <a name="sfixed32" /> sfixed32 | Always four bytes. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sfixed64" /> sfixed64 | Always eight bytes. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="bool" /> bool |  | bool | boolean | boolean | bool | bool | boolean | TrueClass/FalseClass |
| <a name="string" /> string | A string must always contain UTF-8 encoded or 7-bit ASCII text. | string | String | str/unicode | string | string | string | String (UTF-8) |
| <a name="bytes" /> bytes | May contain any arbitrary sequence of bytes. | string | ByteString | str | []byte | ByteString | string | String (ASCII-8BIT) |

