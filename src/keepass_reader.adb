with Ada.Text_IO; use Ada.Text_IO;
with Keepass_Header_Reader; use Keepass_Header_Reader;

package body Keepass_Reader is

   function Is_Keepass_Database (Database_File : Stream_IO.File_Type) return Boolean is
      Signature_1 : UInt32;
      Signature_2 : UInt32;
      Data_Stream : constant Stream_IO.Stream_Access := Stream_IO.Stream (Database_File);
   begin
      Set_Index (Database_File, 1);
      UInt32'Read (Data_Stream, Signature_1);
      UInt32'Read (Data_Stream, Signature_2);

      return Signature_1 = Expected_Signature_1
        and then Signature_2 = Expected_Signature_2;
   end Is_Keepass_Database;

   function Get_Version (Database_File : Stream_IO.File_Type) return Version is
      Major_Version : UInt16;
      Minor_Version : UInt16;
      Data_Stream : constant Stream_IO.Stream_Access := Stream_IO.Stream (Database_File);
   begin
      if not Is_Keepass_Database (Database_File) then
         raise Not_A_Keepass_Database;
      end if;

      Set_Index (Database_File, 9);
      UInt16'Read (Data_Stream, Minor_Version);
      UInt16'Read (Data_Stream, Major_Version);

      return (Major_Version, Minor_Version);
   end Get_Version;

   procedure Dump_Header (Database_File : Stream_IO.File_Type) is
   begin
      Put_Line (Get_Header (Database_File)'Image);
   end Dump_Header;

end Keepass_Reader;
