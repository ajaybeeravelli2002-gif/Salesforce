public class DMLStatements {
    public static void funmen(){
        List<Opportunity> li =[Select Id,Name from Opportunity where isDeleted=true ALL ROWS];
        System.debug(li);
    }
    
}