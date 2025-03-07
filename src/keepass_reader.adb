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
      Raw_Field_Id : Byte;
      Length : UInt32;
      Data_Stream : constant Stream_IO.Stream_Access := Stream_IO.Stream (Database_File);
   begin
      Set_Index (Database_File, 13);

      loop
         Byte'Read (Data_Stream, Raw_Field_Id);
         UInt32'Read (Data_Stream, Length);

         Put_Line (Get_Field_Id (Raw_Field_Id)'Image & ":" & Length'Image);

         case Get_Field_Id (Raw_Field_Id) is
         when End_Of_Header =>
            declare
               End_Of_Header_Field_Value : End_Of_Header_Field;
            begin
               End_Of_Header_Field'Read (Data_Stream, End_Of_Header_Field_Value);
               Put_Line (End_Of_Header_Field_Value'Image);
               exit;
            end;
         when Encryption_Algorithm =>
            declare
               Encryption_Algorithm_UUID : UUID;
            begin
               UUID'Read (Data_Stream, Encryption_Algorithm_UUID);
               Put_Line (Get_Encryption_Algorithm (Encryption_Algorithm_UUID)'Image);
            end;
         when others =>
            Put_Line ("Not implemented");
            declare
               Unusued_Buffer : Byte;
            begin
               for I in 1 .. Length loop
                  Byte'Read (Data_Stream, Unusued_Buffer);
               end loop;
            end;
         end case;

         Put_Line("");
      end loop;
   end Dump_Header;

end Keepass_Reader;
