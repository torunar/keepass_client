with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;

package Variant_Dictionary is

   function Read (Data_Stream : Stream_Access) return Byte_Array_Maps.Map;

end Variant_Dictionary;
