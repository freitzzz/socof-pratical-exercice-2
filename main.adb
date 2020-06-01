with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Interfaces; use Interfaces;
with Ada.Calendar; use Ada.Calendar;
with Ada.Strings.Unbounded;



procedure Main is
   
   -- Pseudo Random Generator: https://stackoverflow.com/a/26799708
   
   package RandGen is
      function generate_random_number ( n: in Positive) return Positive;

   end RandGen;

   package body RandGen is
      subtype Rand_Range is Positive;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      
      gen : Rand_Int.Generator;

      function generate_random_number ( n: in Positive) return Positive is
      begin
         return Rand_Int.Random(gen) mod n + 1;  -- or mod n+1 to include the end value
      end generate_random_number;

      -- package initialisation part
   
   
   begin
      Rand_Int.Reset(gen);
   end RandGen;
   
   
   -- Task that simulates the watch of IoT Device Simulator Memory and CPU usage

   
   task IoTDeviceSimulatorTask is
      entry Query_Info(MemoryInBytes: out Unsigned_64; CPUInPercentage: out Integer);
   
   end IoTDeviceSimulatorTask;
   
   task body IoTDeviceSimulatorTask is
      
      Delay_Time: Duration;
      
   begin
   
      loop
         
         -- wait for accept at maximum of 3 seconds
         -- if accept request
         --   then generate random number indicating device memory in bytes left with a max of 8GB
         --   then generate random number indicating CPU percentage left with a max of 100%
         -- else
         --   sleep at maximum of 3 seconds
         --   loop again
         
         Delay_Time := Duration(RandGen.generate_random_number(3));
         
         select
         
            accept Query_Info(MemoryInBytes: out Unsigned_64; CPUInPercentage: out Integer) do
            
               MemoryInBytes := Shift_Left(Unsigned_64(RandGen.generate_random_number(8192)), 20);
            
               CPUInPercentage := RandGen.generate_random_number(100);
            
            end;
         
         or delay Delay_Time;
            
            Delay_Time := Duration(RandGen.generate_random_number(3));
            
            delay Delay_Time;
            
         end select;
         
      end loop;
   end IoTDeviceSimulatorTask;
   
   task QueryTask is
      
   end QueryTask;
   
   task body QueryTask is
   
      Interval: constant Duration:= Duration(30);
      Interval_Max_Time_Query: constant Duration := Duration(2);
      Next_Time: Time := Clock + Interval;
      Max_Time_Query: Time := Next_Time + Interval_Max_Time_Query;
      Times_Queried : Integer := 0;
      MemoryInBytes: Unsigned_64;
      CPUPercentage: Integer;

   begin
      loop
         
         Ada.Text_IO.Put_Line("Sleeping until next query ...");
         
         delay until Next_Time;
         
         Ada.Text_IO.Put_Line("Starting Query....");
         
         select

            IoTDeviceSimulatorTask.
              Query_Info(MemoryInBytes, CPUPercentage);
            Times_Queried := Times_Queried + 1;
            
            -- Query Info Header Print

            Ada.Text_IO.Put("Query Info: ");
            Ada.Text_IO.Put_Line(Integer'Image(Times_Queried));
            
            -- Memory In Bytes Print
            
            Ada.Text_IO.Put("Memory Available (Bytes): ");
            Ada.Text_IO.Put_Line(Unsigned_64'Image(MemoryInBytes));
            
            -- CPU Info Print
            
            Ada.Text_IO.Put("CPU Availablity (%): ");
            Ada.Text_IO.Put_Line(Integer'Image(CPUPercentage));
            
           
            
         or
            delay until Max_Time_Query;
            
            Ada.Text_IO.Put_Line("<<<< WARNING >>>> Query was not resolved in less than 2 seconds!");
            
         end select;
         
         Ada.Text_IO.Put_Line("Query ended.");

         Next_Time := Next_Time + Interval;
         
         Max_Time_Query := Next_Time + Interval_Max_Time_Query;
         
      end loop;
   
   end QueryTask;
   

begin
   null;
end Main;

