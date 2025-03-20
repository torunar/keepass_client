package body Variant_Dictionary is

   function Read (Data_Stream : Stream_Access) return Byte_Array_Maps.Map is
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
   end Read;

end Variant_Dictionary;
