with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;
with KDF_Reader; use KDF_Reader;

package Keepass_Header_Reader is

   package Stream_IO renames Ada.Streams.Stream_IO;

   subtype End_Of_Header_Field is Byte_Array (1 .. 4);
   subtype Salt is Byte_Array (1 .. 32);

   type Field_Id is (End_Of_Header, Encryption_Algorithm, Compression_Algorithm, Master_Salt, Encryption_IV, KDF_Parameters, Public_Custom_Data);
   Raw_Encryption_Algorithm : constant Byte := 2;
   Raw_Compression_Algorithm : constant Byte := 3;
   Raw_Master_Salt : constant Byte := 4;
   Raw_Encryption_IV : constant Byte := 7;
   Raw_KDF_Parameters : constant Byte := 11;
   Raw_Public_Custom_Data : constant Byte := 12;
   Raw_End_Of_Header : constant Byte := 0;

   type Encryption_Algorithms is (AES_256, Cha_Cha_20);
   AES_256_UUID : constant UUID := [49, 193, 242, 230, 191, 113, 67, 80, 190, 88, 5, 33, 106, 252, 90, 255]; -- 31C1F2E6BF714350BE5805216AFC5AFF
   Cha_Cha_20_UUID : constant UUID := [214, 3, 138, 43, 139, 111, 76, 181, 165, 36, 51, 154, 49, 219, 181, 154]; -- D6038A2B8B6F4CB5A524339A31DBB59A

   type Compression_Algorithms is (No_Compression, GZip);

   type Initialization_Vector_Acc is access Byte_Array;

   type Database_Header is record
      Encryption_Algorithm : Encryption_Algorithms;
      Compression_Algorithm : Compression_Algorithms;
      Master_Salt : Salt := [others => 0];
      Encryption_IV : Initialization_Vector_Acc;
      KDF_Parameters : Boolean;
      Public_Custom_Data : Boolean;
   end record;

   Invalid_Header_Id : exception;
   Unknown_Encryption_Algorithm : exception;
   Unknown_Compression_Algorithm : exception;

   function Get_Header (Database_File : Stream_IO.File_Type) return Database_Header;

   function Get_Field_Id (Raw_Value : Byte) return Field_Id;

   function Get_Encryption_Algorithm (Raw_Value : UUID) return Encryption_Algorithms;

   function Get_Compression_Algorithm (Raw_Value : UInt32) return Compression_Algorithms;

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Field) return Boolean;

   procedure Read_Encryption_Algorithm (Data_Stream : Stream_IO.Stream_Access; Header : out Database_Header);

   procedure Read_Compression_Algorithm (Data_Stream : Stream_IO.Stream_Access; Header : out Database_Header);

   procedure Read_Encryption_IV (Data_Stream : Stream_IO.Stream_Access; Header : out Database_Header);

   procedure Read_KDF_Parameters (Data_Stream : Stream_IO.Stream_Access; Header : out Database_Header);

end Keepass_Header_Reader;
