package body KDF_Parameters is

   function Get_KDF_UUID (Raw_Value : UUID) return KDF_UUID is
   begin
      if Raw_Value = Raw_AES then
         return AES_KDF;
      end if;

      if Raw_Value = Raw_Argon_2_D then
         return Argon_2_D;
      end if;

      if Raw_Value = Raw_Ardong_2_Id then
         return Argon_2_Id;
      end if;

      raise Unknown_KDF_UUID;
   end Get_KDF_UUID;

end KDF_Parameters;
