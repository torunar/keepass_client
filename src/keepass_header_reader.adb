package body Keepass_Header_Reader is

   function Get_Field_Id (Raw_Value : Byte) return Field_Id is
   begin
      case Raw_Value is
         when Raw_End_Of_Header => return End_Of_Header;
         when Raw_Encryption_Algorithm => return Encryption_Algorithm;
         when Raw_Compression_Algorithm => return Compression_Algorithm;
         when Raw_Master_Salt => return Master_Salt;
         when Raw_Encryption_IV => return Encryption_IV;
         when Raw_KDF_Parameters => return KDF_Parameters;
         when Raw_Public_Custom_Data => return Public_Custom_Data;
         when others => raise Invalid_Header_Id;
      end case;
   end Get_Field_Id;

   function Get_Encryption_Algorithm (Raw_Value : UUID) return Encryption_Algorithms is
   begin
      if Raw_Value = AES_256_UUID then
         return AES_256;
      end if;

      if Raw_Value = Cha_Cha_20_UUID then
         return Cha_Cha_20;
      end if;

      raise Invalid_Encryption_Algorithm_UUID;
   end Get_Encryption_Algorithm;

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Field) return Boolean is
   begin
      return Raw_Value = [0, 0, 0, 0];
   end Is_Valid_End_Of_Header;

end Keepass_Header_Reader;
