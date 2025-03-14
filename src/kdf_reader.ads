with Primitives; use Primitives;

package KDF_Reader is

   pragma Elaborate_Body;

   type KDF is (AES_KDF, Argon_2_D, Argon_2_Id);
   Raw_AES_KDF : constant UUID := [others => 0];
   Raw_Argon_2_D : constant UUID := [others => 0];
   Raw_Ardong_2_Id: constant UUID := [others => 0];
   
   type Dictionary_Version is record
      Major : Byte;
      Minor : Byte;
   end record;

end KDF_Reader;
