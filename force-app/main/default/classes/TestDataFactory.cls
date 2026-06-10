@isTest
public class TestDataFactory {
    public static List<Account> createAccountRecords(Boolean isInsert, Integer count){
	   return TestDataFactory.createAccountRecords('TestAccount',isInsert,count);
    }
    public static List<Account> createAccountRecords(String name, Boolean isInsert, Integer count){
	    List<Account> accList = new List<Account>();
        for(Integer i=0;i<count;i++){
            accList.add(new Account(Name=name+i,AnnualRevenue=0.0));
        }
        return accList;
    }
    public static Account createAccount(Boolean isInsert,String name){
        //String.isBlank(name) this handles scenario of name is null, empty(''), containing only white spaces('   ')
        //if you want to check for null you can try (name==null)
            if(!String.isBlank(name)){
           	 return new Account(Name=name,AnnualRevenue=0.0);
			}
            else {
               return new Account(Name='testAccount');
            }
	}
    Public static List<Opportunity> createOpportunityRecords(Boolean isInsert,Integer count){
        List<Opportunity> oppList= new List<Opportunity>();
        for(integer i=0;i<count;i++){
            Opportunity opp = new Opportunity(
            	Name='testOpportunity'+i+'-'+i,
                CloseDate = Date.today().addDays(2),
                Amount=123400+i,
                StageName='Prospecting'
            );
            oppList.add(opp);
        }
        return oppList;
    }
    
}