import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

public class Example {
    @CEntryPoint(name = "add")
    static int add(IsolateThread thread, int a, int b) {
        return a + b;
    }
}
