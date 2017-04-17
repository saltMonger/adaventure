with Ada.Finalization;
generic
   type Element_Type is private;
package Unbounded_Queue is

   -- This package implements FIFO queue, a data structure in which 
   -- elements are added to the rear and removed from the front; 
   -- a "first in, first out" (FIFO) structure.

   type Queue_Type is new Ada.Finalization.Limited_Controlled with private;

   OVERFLOW  : exception;
   UNDERFLOW : exception;

   ----------------------------------------------------------------------------
   procedure Clear (Queue : in out Queue_Type);
   -- Purpose        : Remove all elements from the queue
   -- Preconditions  : None
   -- Postconditions : Queue is empty; it contains no elements

   ----------------------------------------------------------------------------
   procedure Enqueue (Queue : in out Queue_Type;
                      Item  : in     Element_Type);
   -- Purpose        : Adds Item to the rear of Queue
   -- Preconditions  : None
   -- Postconditions : Queue = original Queue with Item added to its rear
   -- Exceptions     : OVERFLOW  Raised on attempt to Enqueue an element onto
   --                            a full queue.  Queue is unchanged.

   ----------------------------------------------------------------------------
   procedure Dequeue (Queue : in out Queue_Type;
                      Item  :    out Element_Type);
   -- Purpose        : Removes the front element from Queue and returns it
   -- Preconditions  : None
   -- Postconditions : Queue = original Queue with front element removed
   --                  Item  = front element of original Queue
   -- Exceptions     : UNDERFLOW  Raised on attempt to dequeue an element from 
   --                             an empty Queue.  Queue remains empty.

   ----------------------------------------------------------------------------
   function Full (Queue : in Queue_Type) return Boolean;
   -- Purpose        : Tests whether a queue is full.  A queue is full when
   --                     no more elements can be enqueued into it
   -- Preconditions  : None
   -- Postconditions : Full = (no more elements can be enqueued into Queue)

   ----------------------------------------------------------------------------
   function Empty (Queue : in Queue_Type) return Boolean;
   -- Purpose        : Tests whether a queue is empty (contains no elements)
   -- Preconditions  : None
   -- Postconditions : Empty = (Queue is empty)
   ----------------------------------------------------------------------------
   function QueueSize(Queue : in Queue_Type) return Integer;
   -- Purpose		 : Returns the depth of the queue.
   -- Preconditions	 : None
   -- Postconditions : None
   
private

   type Node_Type;
   type Node_Ptr is access Node_Type;
   type Node_Type is
      record
         Info : Element_Type;
         Next : Node_Ptr;
      end record;

   type Queue_Type is new Ada.Finalization.Limited_Controlled with
      record
        Front : Node_Ptr;  -- Designates first item in the queue
        Rear  : Node_Ptr;  -- Designates last item in the queue
      end record;
      
   overriding procedure Finalize (Object : in out Queue_Type) renames Clear;
   
end Unbounded_Queue;
