package Keepass_Header_Reader is

   type Byte is mod 2 ** 8;

   type Field_Id is (End_Of_Header, Encryption_Algorithm, Compression_Algorithm, Master_Salt, Encryption_IV, KDF_Parameters, Public_Custom_Data);

   type Encryption_Algorithms is (AES_256, Cha_Cha_20);

   type UUID_Index is range 1 .. 16;

   type UUID is array (UUID_Index) of Byte;

   type End_Of_Header_Field_Index is range 1 .. 4;

   type End_Of_Header_Field is array (End_Of_Header_Field_Index) of Byte;

   Invalid_Header_Id : exception;

   Invalid_Encryption_Algorithm_UUID : exception;

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

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Field) return Boolean;

end Keepass_Header_Reader;
