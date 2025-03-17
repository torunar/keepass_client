with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Primitives; use Primitives;

package KDF_Reader is
   
   package Stream_IO renames Ada.Streams.Stream_IO;

   type KDF_UUID is (AES_KDF, Argon_2_D, Argon_2_Id);
   Raw_AES : constant UUID := [201, 217, 243, 154, 98, 138, 68, 96, 191, 116, 13, 8, 193, 138, 79, 234];
   Raw_Argon_2_D : constant UUID := [239, 99, 109, 223, 140, 41, 68, 75, 145, 247, 169, 164, 3, 227, 10, 12];
   Raw_Ardong_2_Id: constant UUID := [158, 41, 139, 25, 86, 219, 71, 115, 178, 61, 252, 62, 198, 240, 161, 230];
   
   type Dictionary_Version is record
      Major : Byte;
      Minor : Byte;
   end record;
   
   type KDF is tagged record
      Version : Dictionary_Version;
      UUID : KDF_UUID;
   end record;
   
   type KDF_Acc is access all KDF;
   
   procedure Read_KDF_UUID (Data_Stream : Stream_IO.Stream_Access; Value : in out KDF);
   
   type AES_Salt is array (1 .. 32) of Byte;
   
   type AES is new KDF with record
      Salt : AES_Salt;
      Rounds : UInt64;
   end record;
   
   type AES_Acc is access AES;
   
   type Argon_2_Salt is array (Integer range <>) of Byte;
   type Argon_2_Salt_Acc is access Argon_2_Salt;
   
   type Argon_2 is new KDF with record
      Argon_Version : UInt32;
      Salt : Argon_2_Salt_Acc;
      Iterations : UInt64;
      Memory : UInt64;
      Parallelism : UInt32;
   end record;
   
   type Argon_2_Acc is access Argon_2;
   
   Unknown_KDF_UUID : exception;
   
   function Get_KDF_UUID (Raw_Value : UUID) return KDF_UUID;

end KDF_Reader;
