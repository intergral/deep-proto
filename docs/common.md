# Protocol Documentation
<a name="top"></a>

## Table of Contents

- [deepproto/proto/common/v1/common.proto](#deepproto_proto_common_v1_common-proto)
    - [AnyValue](#deepproto-proto-common-v1-AnyValue)
    - [ArrayValue](#deepproto-proto-common-v1-ArrayValue)
    - [KeyValue](#deepproto-proto-common-v1-KeyValue)
    - [KeyValueList](#deepproto-proto-common-v1-KeyValueList)
  
- [Scalar Value Types](#scalar-value-types)



<a name="deepproto_proto_common_v1_common-proto"></a>
<p align="right"><a href="#top">Top</a></p>

## deepproto/proto/common/v1/common.proto



<a name="deepproto-proto-common-v1-AnyValue"></a>

### AnyValue
AnyValue is used to represent any type of attribute value. AnyValue may contain a
primitive value such as a string or integer or it may contain an arbitrary nested
object containing arrays, key-value lists and primitives.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| string_value | [string](#string) |  |  |
| bool_value | [bool](#bool) |  |  |
| int_value | [int64](#int64) |  |  |
| double_value | [double](#double) |  |  |
| array_value | [ArrayValue](#deepproto-proto-common-v1-ArrayValue) |  |  |
| kvlist_value | [KeyValueList](#deepproto-proto-common-v1-KeyValueList) |  |  |
| bytes_value | [bytes](#bytes) |  |  |






<a name="deepproto-proto-common-v1-ArrayValue"></a>

### ArrayValue
ArrayValue is a list of AnyValue messages. We need ArrayValue as a message
since oneof in AnyValue does not allow repeated fields.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| values | [AnyValue](#deepproto-proto-common-v1-AnyValue) | repeated | Array of values. The array may be empty (contain 0 elements). |






<a name="deepproto-proto-common-v1-KeyValue"></a>

### KeyValue
KeyValue is a key-value pair that is used to store Span attributes, Link
attributes, etc.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [AnyValue](#deepproto-proto-common-v1-AnyValue) |  |  |






<a name="deepproto-proto-common-v1-KeyValueList"></a>

### KeyValueList
KeyValueList is a list of KeyValue messages. We need KeyValueList as a message
since `oneof` in AnyValue does not allow repeated fields. Everywhere else where we need
a list of KeyValue messages (e.g. in Span) we use `repeated KeyValue` directly to
avoid unnecessary extra wrapping (which slows down the protocol). The 2 approaches
are semantically equivalent.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| values | [KeyValue](#deepproto-proto-common-v1-KeyValue) | repeated | A collection of key/value pairs of key-value pairs. The list may be empty (may contain 0 elements). The keys MUST be unique (it is not allowed to have more than one value with the same key). |





 

 

 

 



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

