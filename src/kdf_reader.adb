package body KDF_Reader is

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

   procedure Read_KDF_UUID ( Data_Stream : Stream_IO.Stream_Access; Value : in out KDF) is
      Raw_Value : UUID;
   begin
      UUID'Read (Data_Stream, Raw_Value);
      Value.UUID := Get_KDF_UUID (Raw_Value);
   end Read_KDF_UUID;

end KDF_Reader;
