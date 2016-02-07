
import java.util.concurrent.locks.ReentrantLock;

class BetterSafe implements State {
    private byte[] value;
    private byte maxval;
    private final ReentrantLock swapLock;

    BetterSafe(byte[] v) {
        value = v; maxval = 127;
        swapLock = new ReentrantLock();
    }

    BetterSafe(byte[] v, byte m) {
        value = v; maxval = m;
        swapLock = new ReentrantLock();
    }

public int size() { return value.length; }

public byte[] current() { return value; }

public boolean swap(int i, int j) {
    swapLock.lock();
    
    if (value[i] <= 0 || value[j] >= maxval) {
        swapLock.unlock();

        return false;
    }
    value[i]--;
    value[j]++;

    swapLock.unlock();
    
    return true;
                            }
}
