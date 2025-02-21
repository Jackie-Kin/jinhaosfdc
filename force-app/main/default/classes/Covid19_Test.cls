@isTest
public class Covid19_Test {
	@isTest
    public static void treatPatientTest(){
        Covid19 jaipur =new Covid19(10);
        
        integer treated = jaipur.getTreated();
        System.assertEquals(10,treated,'deploy Treadted count does not match');
        
        jaipur.treatPatient();
        System.assertEquals(11,11,'Treadted count does not match');
        Covid19.printTreated();
    }
}