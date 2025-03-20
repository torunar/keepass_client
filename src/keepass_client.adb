with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Keepass_Reader; use Keepass_Reader;
with Header_Reader; use Header_Reader;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

procedure Keepass_Client is
   Database_Path : constant String := Ada.Command_Line.Argument (1);
   Database_File : Ada.Streams.Stream_IO.File_Type;
begin
   Open (Database_File, In_File, Database_Path);

   Put_Line ("Version:" & Get_Version (Database_File)'Image);
   Put_Line ("Header:" & Get_Header (Database_File)'Image);
end Keepass_Client;
