with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;

package Keepass_Header_Reader is

   package Stream_IO renames Ada.Streams.Stream_IO;

   type Field_Id is (End_Of_Header, Encryption_Algorithm, Compression_Algorithm, Master_Salt, Encryption_IV, KDF_Parameters, Public_Custom_Data);

   type Encryption_Algorithms is (AES_256, Cha_Cha_20);

   type Compression_Algorithms is (No_Compression, GZip);

   type UUID is array (1 .. 16) of Byte;

   type End_Of_Header_Field is array (1 .. 4) of Byte;

   type Salt is array (1 .. 32) of Byte;

   type Initialization_Vector_AES_256 is array (1 .. 16) of Byte;
   type Initialization_Vector_Cha_Cha_20 is array (1 .. 12) of Byte;

   type Database_Header is record
      Encryption_Algorithm : Encryption_Algorithms;
      Compression_Algorithm : Compression_Algorithms;
      Master_Salt : Salt := [others => 0];
      Encryption_IV_AES_256 : Initialization_Vector_AES_256 := [others => 0];
      Encryption_IV_Cha_Cha_20 : Initialization_Vector_Cha_Cha_20 := [others => 0];
      KDF_Parameters : Boolean;
      Public_Custom_Data : Boolean;
   end record;

   Invalid_Header_Id : exception;
   Unknown_Encryption_Algorithm : exception;
   Unknown_Compression_Algorithm : exception;

   Raw_End_Of_Header : constant Byte := 0;
   Raw_Encryption_Algorithm : constant Byte := 2;
   Raw_Compression_Algorithm : constant Byte := 3;
   Raw_Master_Salt : constant Byte := 4;
   Raw_Encryption_IV : constant Byte := 7;
   Raw_KDF_Parameters : constant Byte := 11;
   Raw_Public_Custom_Data : constant Byte := 12;

   --  31C1F2E6BF714350BE5805216AFC5AFF
   AES_256_UUID : constant UUID := [49, 193, 242, 230, 191, 113, 67, 80, 190, 88, 5, 33, 106, 252, 90, 255];
   --  D6038A2B8B6F4CB5A524339A31DBB59A
   Cha_Cha_20_UUID : constant UUID := [214, 3, 138, 43, 139, 111, 76, 181, 165, 36, 51, 154, 49, 219, 181, 154];

   function Get_Field_Id (Raw_Value : Byte) return Field_Id;

   function Get_Encryption_Algorithm (Raw_Value : UUID) return Encryption_Algorithms;

   function Get_Compression_Algorithm (Raw_Value : UInt32) return Compression_Algorithms;

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Field) return Boolean;

   function Get_Header (Database_File : Stream_IO.File_Type) return Database_Header;

end Keepass_Header_Reader;
