with Unchecked_Deallocation;
package body Unbounded_Queue is

   -- Instantiate a procedure to recycle node memory
   procedure Free is new Unchecked_Deallocation (Object => Node_Type,
                                                 Name   => Node_Ptr);

   ----------------------------------------------------------------------------
   procedure Clear (Queue : in out Queue_Type) is
      To_Recycle : Node_Ptr;               -- For recycling nodes
   begin
      loop
         exit when Queue.Front = null;
         To_Recycle  := Queue.Front;           -- Unlink the
         Queue.Front := Queue.Front.all.Next;  --    front node
         Free (To_Recycle);                    -- Recycle the node
      end loop;
      Queue.Rear := null;                      -- Clean up Rear pointer
   end Clear;
  
   ----------------------------------------------------------------------------
   procedure Enqueue (Queue : in out Queue_Type;
                      Item  : in     Element_Type) is
   begin
      if Queue.Front = null then    -- Is the queue empty?
         -- Yes, Front and Back should both designate the new node
         Queue.Front := new Node_Type'(Info => Item,  Next => null);
         Queue.Rear  := Queue.Front;
      else
         -- No, link a new node to the rear of the existing queue.
         Queue.Rear.all.Next := new Node_Type'(Info => Item,  Next => null);
         Queue.Rear := Queue.Rear.all.Next;
      end if;
   end Enqueue;

   ----------------------------------------------------------------------------
   procedure Dequeue (Queue : in out Queue_Type;
                      Item  :    out Element_Type) is
      To_Recycle : Node_Ptr;           -- For recycling nodes
   begin
      Item := Queue.Front.Info;        -- Get the value from the front node
      To_Recycle  := Queue.Front;      -- Save access to old front
      Queue.Front := Queue.Front.Next; -- Change the front
      Free (To_Recycle);               -- Recycle the memory
      if Queue.Front = null then       -- Is the queue now empty?
         Queue.Rear := null;           -- Set Rear to null as well
      end if;
   end Dequeue;

   --------------------------------------------------------------------------
   function Full (Queue : in Queue_Type) return Boolean is
   begin
      return False;
   end Full;

   --------------------------------------------------------------------------
   function Empty (Queue : in Queue_Type) return Boolean is
   begin
      return Queue.Front = null;
   end Empty;
	
   --------------------------------------------------------------------------
   function QueueSize(Queue: in Queue_Type) return Integer is
		QueueDepth 	:	Integer	:=	0;
		Current_Pointer	:	Node_Ptr	:=	Queue.Front;	--set pointer to front pointer
   begin
		if(Queue.Front = Queue.Rear) then
			return 1;
		end if;
   
		if(Queue.Front /= null ) then 	--catch if stack is empty, depth is 0
			loop
				exit when Current_Pointer = Queue.Rear;	--end when rear pointer is encountered
				QueueDepth	:=	QueueDepth + 1;
				Current_Pointer	:=	Current_Pointer.All.Next;
			end loop;
		end if;
		return QueueDepth + 1;
		
   end QueueSize;
   
end Unbounded_Queue;
