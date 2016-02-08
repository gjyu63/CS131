JC = javac
OUTPUT = executables/

all: nullstate swaptest synchronized_state state unsafe_memory \
	unsynchronized_state get_n_set better_safe 

# All classes for this assingnment
nullstate : NullState.java
	$(JC) -d $(OUTPUT) NullState.java
swaptest : SwapTest.java
	$(JC) -d $(OUTPUT) SwapTest.java
synchronized_state : SynchronizedState.java
	$(JC) -d $(OUTPUT) SynchronizedState.java
unsynchronized_state : UnsynchronizedState.java unsafe_memory
	$(JC) -d $(OUTPUT) UnsynchronizedState.java
get_n_set : GetNSet.java unsafe_memory
	$(JC) -d $(OUTPUT) GetNSet.java
better_safe : BetterSafe.java unsafe_memory
	$(JC) -d $(OUTPUT) BetterSafe.java
better_sorry : BetterSorry.java unsafe_memory
	$(JC) -d $(OUTPUT) BetterSorry.java
state: State.java
	$(JC) -d $(OUTPUT) State.java
unsafe_memory: UnsafeMemory.java
	$(JC) -d $(OUTPUT) UnsafeMemory.java

clean:
	rm $(OUTPUT)* 
