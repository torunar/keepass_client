with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;
with KDF_Parameters; use KDF_Parameters;
with Variant_Dictionary;

package Header_Reader is

   subtype End_Of_Header_Value is Byte_Array (1 .. 4);
   subtype Salt is Byte_Array (1 .. 32);

   type Field_Id is (End_Of_Header, Encryption_Algorithm, Compression_Algorithm, Master_Salt, Encryption_IV, KDF_Parameters, Public_Custom_Data);

   type Encryption_Algorithms is (AES_256, Cha_Cha_20);

   type Compression_Algorithms is (No_Compression, GZip);

   type Public_Custom_Data_Collection is record
      Version : Variant_Dictionary.Verion;
      Values : Byte_Array_Maps.Map;
   end record;

   type Database_Header is record
      Encryption_Algorithm : Encryption_Algorithms;
      Compression_Algorithm : Compression_Algorithms;
      Master_Salt : Salt := [others => 0];
      Encryption_IV : Byte_Array_Acc;
      KDF_Parameters : KDF;
      Public_Custom_Data : Public_Custom_Data_Collection;
      End_Of_Header : End_Of_Header_Value;
   end record;

   function Get_Header (Database_File : File_Type) return Database_Header;

   Invalid_Header_Id : exception;
   Unknown_Encryption_Algorithm : exception;
   Unknown_Compression_Algorithm : exception;

private

   Raw_Encryption_Algorithm : constant Byte := 2;
   Raw_Compression_Algorithm : constant Byte := 3;
   Raw_Master_Salt : constant Byte := 4;
   Raw_Encryption_IV : constant Byte := 7;
   Raw_KDF_Parameters : constant Byte := 11;
   Raw_Public_Custom_Data : constant Byte := 12;
   Raw_End_Of_Header : constant Byte := 0;

   AES_256_UUID : constant UUID := [49, 193, 242, 230, 191, 113, 67, 80, 190, 88, 5, 33, 106, 252, 90, 255]; -- 0x31C1F2E6BF714350BE5805216AFC5AFF
   Cha_Cha_20_UUID : constant UUID := [214, 3, 138, 43, 139, 111, 76, 181, 165, 36, 51, 154, 49, 219, 181, 154]; -- 0xD6038A2B8B6F4CB5A524339A31DBB59A

   function Get_Field_Id (Raw_Value : Byte) return Field_Id;

   function Get_Encryption_Algorithm (Raw_Value : UUID) return Encryption_Algorithms;

   function Get_Compression_Algorithm (Raw_Value : UInt32) return Compression_Algorithms;

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Value) return Boolean;

   procedure Read_Encryption_Algorithm (Data_Stream : Stream_Access; Header : out Database_Header);

   procedure Read_Compression_Algorithm (Data_Stream : Stream_Access; Header : out Database_Header);

   procedure Read_Encryption_IV (Data_Stream : Stream_Access; Header : in out Database_Header);

   procedure Read_KDF_Parameters (Data_Stream : Stream_Access; Header : out Database_Header);

   procedure Read_Public_Custom_Data (Data_Stream : Stream_Access; Header : out Database_Header);

   procedure Read_End_Of_Header (Data_Stream : Stream_Access; Header : out Database_Header);

end Header_Reader;
