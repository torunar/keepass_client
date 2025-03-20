with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;

package Keepass_Reader is

   type Version is record
      Major : UInt16;
      Minor : UInt16;
   end record;

   Not_A_Keepass_Database : exception;

   function Is_Keepass_Database (Database_File : File_Type) return Boolean;

   function Get_Version (Database_File : File_Type) return Version;

   procedure Dump_Header (Database_File : File_Type);

private

   Expected_Signature_1 : constant UInt32 := 2594363651; -- 0x9AA2D903
   Expected_Signature_2 : constant UInt32 := 3041655655; -- 0xB54BFB67

end Keepass_Reader;
