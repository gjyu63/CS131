
import java.util.concurrent.locks.ReentrantReadWriteLock;

class BetterSafe implements State {
    private byte[] value;
    private byte maxval;
    private final ReentrantReadWriteLock swapLock = new ReentrantReadWriteLock();

    BetterSafe(byte[] v) { value = v; maxval = 127; }

    BetterSafe(byte[] v, byte m) { value = v; maxval = m; }

public int size() { return value.length; }

public byte[] current() { return value; }

public boolean swap(int i, int j) {
    swapLock.writeLock().lock();
    swapLock.readLock().lock();
    
    if (value[i] <= 0 || value[j] >= maxval) {
        return false;
    }
    value[i]--;
    value[j]++;

    swapLock.writeLock().unlock();
    swapLock.readLock().unlock();
    
    return true;
                            }
}
