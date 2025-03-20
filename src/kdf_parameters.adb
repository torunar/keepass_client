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

   procedure Read_KDF_UUID (Data_Stream : Stream_Access; Value : in out KDF) is
      Raw_Value : UUID;
   begin
      UUID'Read (Data_Stream, Raw_Value);
      Value.UUID := Get_KDF_UUID (Raw_Value);
   end Read_KDF_UUID;

   function Get_KDF_Parameters (Data_Stream : Stream_Access) return Byte_Array_Maps.Map is
      Parameters : Byte_Array_Maps.Map;
      Value_Type : Byte;
      Name_Size : UInt32;
      Value_Size : UInt32;
   begin
      loop
         Byte'Read (Data_Stream, Value_Type);
         exit when Value_Type = 0;

         UInt32'Read (Data_Stream, Name_Size);

         declare
            Name : String (1 .. Positive (Name_Size));
         begin
            String'Read (Data_Stream, Name);
            UInt32'Read (Data_Stream, Value_Size);

            declare
               Value : Byte_Array (1 .. Positive (Value_Size));
            begin
               for I in 1 .. Positive (Value_Size) loop
                  Byte'Read (Data_Stream, Value (I));
               end loop;

               Parameters.Include (Name, Value);
            end;
         end;
      end loop;

      return Parameters;
   end Get_KDF_Parameters;

end KDF_Parameters;
