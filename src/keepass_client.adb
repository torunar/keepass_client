with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Keepass_Reader; use Keepass_Reader;

procedure Keepass_Client is
   Database_Path : constant String := Ada.Command_Line.Argument (1);
   Database_File : Stream_IO.File_Type;
begin
   Stream_IO.Open (Database_File, Stream_IO.In_File, Database_Path);

   Put_Line (Is_Keepass_Database (Database_File)'Image);
   Put_Line ("Version:" & Get_Version (Database_File)'Image);

   Dump_Header (Database_File);
end Keepass_Client;
