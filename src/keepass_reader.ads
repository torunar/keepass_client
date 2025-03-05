with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package Keepass_Reader is

   package Stream_IO renames Ada.Streams.Stream_IO;

   type UInt32 is mod 2 ** 32;

   type UInt16 is mod 2 ** 16;

   type Version is record
      Major : UInt16;
      Minor : UInt16;
   end record;

   Not_A_Keepass_Database : exception;

   Expected_Signature_1 : constant UInt32 := 2594363651; -- 0x9AA2D903
   Expected_Signature_2 : constant UInt32 := 3041655655; -- 0xB54BFB67

   function Is_Keepass_Database (Database_File : Stream_IO.File_Type) return Boolean;

   function Get_Version (Database_File : Stream_IO.File_Type) return Version;

end Keepass_Reader;
