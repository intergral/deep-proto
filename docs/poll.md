# Protocol Documentation
<a name="top"></a>

## Table of Contents

- [deepproto/proto/poll/v1/poll.proto](#deepproto_proto_poll_v1_poll-proto)
    - [PollRequest](#deepproto-proto-poll-v1-PollRequest)
    - [PollResponse](#deepproto-proto-poll-v1-PollResponse)
  
    - [ResponseType](#deepproto-proto-poll-v1-ResponseType)
  
    - [PollConfig](#deepproto-proto-poll-v1-PollConfig)
  
- [Scalar Value Types](#scalar-value-types)



<a name="deepproto_proto_poll_v1_poll-proto"></a>
<p align="right"><a href="#top">Top</a></p>

## deepproto/proto/poll/v1/poll.proto



<a name="deepproto-proto-poll-v1-PollRequest"></a>

### PollRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ts_nanos | [fixed64](#fixed64) |  | time message was sent, acts as message id (useful for tracing) |
| current_hash | [string](#string) |  | some id that represents the clients current config, or null if no current config |
| resource | [deepproto.proto.resource.v1.Resource](#deepproto-proto-resource-v1-Resource) |  | this is the attributes that describe the resource requesting a config (e.g. service.name: shop-service) |






<a name="deepproto-proto-poll-v1-PollResponse"></a>

### PollResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ts_nanos | [fixed64](#fixed64) |  | time message was sent, acts as message id (useful for tracing) |
| current_hash | [string](#string) |  | some id that represents the clients current config, or null if no current config |
| response | [deepproto.proto.tracepoint.v1.TracePointConfig](#deepproto-proto-tracepoint-v1-TracePointConfig) | repeated | this would be the list of dynamic configs that are to be installed. This should be the full set, not a partial or delta. Can be null if the response type is &#39;no-change&#39; |
| response_type | [ResponseType](#deepproto-proto-poll-v1-ResponseType) |  | This indicates if the config has changed or not. if &#39;no-change&#39; then &#39;response&#39; will be null/empty |





 


<a name="deepproto-proto-poll-v1-ResponseType"></a>

### ResponseType


| Name | Number | Description |
| ---- | ------ | ----------- |
| NO_CHANGE | 0 | This is sent when the &#39;currentHash&#39; from the request is the same as the response. So the client should do nothing. |
| UPDATE | 1 | This is sent when the client should process the response to update the config. |


 

 


<a name="deepproto-proto-poll-v1-PollConfig"></a>

### PollConfig
This is how the application agent should request the config of the tracepoints.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| poll | [PollRequest](#deepproto-proto-poll-v1-PollRequest) | [PollResponse](#deepproto-proto-poll-v1-PollResponse) | Call this function as often as is required to ensure config is up to date. |

 



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

