
import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State {
    private int[] value;
    private byte maxval;
    private AtomicIntegerArray valueIntegerArray;

GetNSet(byte[] v) {
    value = new int[v.length];

    for(int i = 0; i < value.length; i++){
        value[i] = v[i];
    }
    
    maxval = 127;
    valueIntegerArray = new AtomicIntegerArray(value);
}

GetNSet(byte[] v, byte m) { 
    value = new int[v.length];

    for(int i = 0; i < value.length; i++){
        value[i] = v[i];
    }
    
    maxval = m;
    valueIntegerArray = new AtomicIntegerArray(value);
}

public int size() { return valueIntegerArray.length(); }

public byte[] current() {
    byte[] tmp = new byte[value.length];

    for(int i = 0; i < tmp.length; i++){
        tmp[i] = (byte) value[i];
    }
    
    return tmp;
}

public boolean swap(int i, int j) {
        if (valueIntegerArray.get(i) <= 0 || valueIntegerArray.get(j) >= maxval) {
            return false;
        }
        valueIntegerArray.getAndDecrement(i);
        valueIntegerArray.getAndIncrement(j);
        return true;
    }
}
