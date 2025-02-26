/**
 * Covid19 Class
 * Track covid19 recovery
 * */
public class Covid19 {
    public Integer recoveredInArea = 0;
    public static Integer recoveredInCountry = 0;

    // initialization block 1
    {
        System.debug('Initilization Block 1 is Called');
    }

    // initialization block 2
    {
        System.debug('Initilization Block 2 is Called');
    }

    // static initialization block 1
    static {
        System.debug('Static Initilization Block 1 is Called');
    }

    // static initialization block 2
    static {
        System.debug('Static Initilization Block 2 is Called');
    }

    // blank constructor
    public Covid19(){
        System.debug('Blank Constructor is called');
    }

    // parameterized constructor to set class variables value
    public Covid19(Integer recoveredInArea){
        // calling blank constructor
        this();
        System.debug('Parameterized Constructor is called');
        this.recoveredInArea=recoveredInArea;
        recoveredInCountry+=recoveredInArea;
    }

    public void treatPatient(){
        recoveredInArea++;
        recoveredInCountry++;
    }

    public static void printTreated(){
        System.debug('Recovered in country : '+recoveredInCountry);
    }
    
    public integer getTreated(){
        return recoveredInArea;
    }
}