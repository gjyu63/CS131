JC = javac
OUTPUT = executables/

all: nullstate swaptest synchronized_state state unsafe_memory

# All classes for this assingnment
nullstate : NullState.java
	$(JC) -d $(OUTPUT) NullState.java
swaptest : SwapTest.java
	$(JC) -d $(OUTPUT) SwapTest.java
synchronized_state : SynchronizedState.java
	$(JC) -d $(OUTPUT) SynchronizedState.java
state: State.java
	$(JC) -d $(OUTPUT) State.java
unsafe_memory: UnsafeMemory.java
	$(JC) -d $(OUTPUT) UnsafeMemory.java

clean:
	rm $(OUTPUT)* 
