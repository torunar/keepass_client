package Primitives is

   pragma Elaborate_Body;

   type Byte is mod 2 ** 8;

   type UInt16 is mod 2 ** 16;

   type UInt32 is mod 2 ** 32;

   type UInt64 is mod 2 ** 64;
   
   type Byte_Array is array (Integer range <>) of Byte;
   subtype UUID is Byte_Array (1 .. 16);

end Primitives;
