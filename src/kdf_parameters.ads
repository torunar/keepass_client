with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;
with Variant_Dictionary;

package KDF_Parameters is

   type KDF_UUID is (AES_KDF, Argon_2_D, Argon_2_Id);
   
   type KDF is record
      Version : Variant_Dictionary.Verion;
      UUID : KDF_UUID;
      Values : Byte_Array_Maps.Map;
   end record;
   
   Unknown_KDF_UUID : exception;
   
   procedure Read_KDF_UUID (Data_Stream : Stream_Access; Value : in out KDF);
   
   function Get_KDF_UUID (Raw_Value : UUID) return KDF_UUID;

private

   Raw_AES : constant UUID := [201, 217, 243, 154, 98, 138, 68, 96, 191, 116, 13, 8, 193, 138, 79, 234]; -- 0xC9D9F39A628A4460BF740D08C18A4FEA
   Raw_Argon_2_D : constant UUID := [239, 99, 109, 223, 140, 41, 68, 75, 145, 247, 169, 164, 3, 227, 10, 12]; -- 0xEF636DDF8C29444B91F7A9A403E30A0C
   Raw_Ardong_2_Id: constant UUID := [158, 41, 139, 25, 86, 219, 71, 115, 178, 61, 252, 62, 198, 240, 161, 230]; -- 0x9E298B1956DB4773B23DFC3EC6F0A1E6

end KDF_Parameters;
