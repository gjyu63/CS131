
import java.util.concurrent.TimeUnit;

class BetterSorry implements State {
    private volatile byte[] value;
    private byte maxval;
    private static volatile boolean inCritical = false;

BetterSorry(byte[] v) { value = v; maxval = 127; }

BetterSorry(byte[] v, byte m) { value = v; maxval = m; }

public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
        int v_i = value[i], v_j = value[j];

        if (v_i <= 0 || v_j >= maxval) {
            return false;
        }
        while(inCritical) {
            try {
                TimeUnit.MILLISECONDS.sleep(1);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        inCritical = true;
        
        value[i]--;
        value[j]++;

        inCritical = false;

        
        return true;
    }
}
