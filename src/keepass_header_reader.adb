package body Keepass_Header_Reader is

   function Get_Field_Id (Raw_Value : Byte) return Field_Id is
   begin
      case Raw_Value is
      when Raw_End_Of_Header =>
         return End_Of_Header;
      when Raw_Encryption_Algorithm =>
         return Encryption_Algorithm;
      when Raw_Compression_Algorithm =>
         return Compression_Algorithm;
      when Raw_Master_Salt =>
         return Master_Salt;
      when Raw_Encryption_IV =>
         return Encryption_IV;
      when Raw_KDF_Parameters =>
         return KDF_Parameters;
      when Raw_Public_Custom_Data =>
         return Public_Custom_Data;
      when others =>
         raise Invalid_Header_Id;
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

      raise Unknown_Encryption_Algorithm;
   end Get_Encryption_Algorithm;

   function Get_Compression_Algorithm (Raw_Value : UInt32) return Compression_Algorithms is
   begin
      case Raw_Value is
      when 0 =>
         return No_Compression;
      when 1 =>
         return GZip;
      when others =>
         raise Unknown_Compression_Algorithm;
      end case;
   end Get_Compression_Algorithm;

   function Is_Valid_End_Of_Header (Raw_Value : End_Of_Header_Field) return Boolean is
   begin
      return Raw_Value = [0, 0, 0, 0];
   end Is_Valid_End_Of_Header;

   function Get_Header (Database_File : Stream_IO.File_Type) return Database_Header is
      Header : Database_Header;
      Raw_Field_Id : Byte;
      Length : UInt32;
      Data_Stream : constant Stream_IO.Stream_Access := Stream_IO.Stream (Database_File);
   begin
      Set_Index (Database_File, 13);

      loop
         Byte'Read (Data_Stream, Raw_Field_Id);
         UInt32'Read (Data_Stream, Length);

         case Get_Field_Id (Raw_Field_Id) is
         when Encryption_Algorithm =>
            declare
               Raw_Value : UUID;
            begin
               UUID'Read (Data_Stream, Raw_Value);
               Header.Encryption_Algorithm := Get_Encryption_Algorithm (Raw_Value);
            end;
         when Compression_Algorithm =>
            declare
               Raw_Value : UInt32;
            begin
               UInt32'Read (Data_Stream, Raw_Value);
               Header.Compression_Algorithm := Get_Compression_Algorithm (Raw_Value);
            end;
         when Master_Salt =>
            Salt'Read (Data_Stream, Header.Master_Salt);
         when Encryption_IV =>
            case Header.Encryption_Algorithm is
            when AES_256 =>
               Initialization_Vector_AES_256'Read (Data_Stream, Header.Encryption_IV_AES_256);
            when Cha_Cha_20 =>
               Initialization_Vector_Cha_Cha_20'Read (Data_Stream, Header.Encryption_IV_Cha_Cha_20);
            end case;
         when KDF_Parameters =>
            null;
         when Public_Custom_Data =>
            null;
         when End_Of_Header =>
            declare
               End_Of_Header_Field_Value : End_Of_Header_Field := [others => 0];
            begin
               End_Of_Header_Field'Read (Data_Stream, End_Of_Header_Field_Value);
               exit;
            end;
         end case;
      end loop;

      return Header;
   end Get_Header;

end Keepass_Header_Reader;
