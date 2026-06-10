@isTest
class TriggerTestAnnualRevenue {
	@isTest
    static void testInsert(){
        List<Account> oldAccounts= TestDataFactory.createAccountRecords('Ajay',false,2);
        Integer nopp=10;
        List<Opportunity> oppList= TestDataFactory.createOpportunityRecords(false,nopp);
        Map<Id,Account> oldMap= new Map<Id,Account>();
        
        Test.startTest();
            insert oldAccounts;
        	oldAccounts=[select Id,AnnualRevenue from Account order by CreatedDate DESC limit 2];
        	for(Account a:oldAccounts){
                oldMap.put(a.Id,a);
			}
            integer d = nopp/oldAccounts.size();
            for(Integer i=0;i<oldAccounts.size();i++){
                for(integer j=i*d;j<(i*d+d);j++){
                    oppList[j].AccountId=oldAccounts[i].Id;
                }
            }
          insert oppList;
        Test.stopTest();
        
        Map<Id,Double> oppAmountSum= new Map<Id,Double>();
        for(Opportunity opp : oppList){
            if(oppAmountSum.containsKey(opp.AccountId)){
              	oppAmountSum.put(opp.AccountId,oppAmountSum.get(opp.AccountId)+opp.Amount);
            }
            else{
			    oppAmountSum.put(opp.AccountId,opp.Amount);
            }
        }
        List<Account> naccList= [select Id,AnnualRevenue from Account where Id in :oldAccounts];
        Map<Id,Account> macc= new Map<Id,Account>();
        for(Account al:naccList){
			System.assertEquals(al.AnnualRevenue,oldMap.get(al.Id).AnnualRevenue+oppAmountSum.get(al.Id));
        }  
    }
    
    @isTest
    static void testUpdate(){
        
        List<Account> oldAccounts= TestDataFactory.createAccountRecords('Ajay',false,2);
        Integer nopp=10;
        List<Opportunity> oppList= TestDataFactory.createOpportunityRecords(false,nopp);
        Map<Id,Double> annualRevenueTracking = new Map<Id,Double>();
        
        Test.startTest();
        insert oldAccounts;
        oldAccounts =[select Id,AnnualRevenue from Account order by CreatedDate DESC limit 2];
        Integer d = nopp/oldAccounts.size();
        for(Integer i=0;i<oppList.size();i++ ){
            for(Integer j=i*d;j<Math.min(i*d+d,opplist.size());j++){
                oppList[j].AccountId=oldAccounts[i].Id;
            }
        }
        insert oppList;
        oppList=[select Id, amount, AccountId from Opportunity order by CreatedDate Desc limit :nopp];
        List<Account> StageAccounts =[select Id,AnnualRevenue from Account order by CreatedDate DESC limit 2 ];
        for(Account a:StageAccounts){
            annualRevenueTracking.put(a.Id,a.AnnualRevenue);
        }
        //updating opportunities
        for(integer i=0; i<nopp;i++){
            integer s= (Integer)Math.floor(Math.Random()*StageAccounts.size());
            if(oppList[i].AccountId!=null){
                Id oldId=oppList[i].AccountId;
                Id newID=StageAccounts[s].Id;
                oppList[i].AccountId=newId;
                annualRevenueTracking.put(newId,annualRevenueTracking.get(newId)+oppList[i].Amount);
                annualRevenueTracking.put(oldId,annualRevenueTracking.get(oldId)-oppList[i].Amount);
            }
        }
        update oppList;
        Test.stopTest();
        
        List<Account> newAccounts= [select Id,AnnualRevenue from Account order by CreatedDate DESC limit 2];
        for( Account a:newAccounts){
            System.assertEquals(a.annualRevenue,annualRevenueTracking.get(a.Id));
        }
    }
    
    @isTest
    static void testDelete(){
        List<Account> oldAccounts= TestDataFactory.createAccountRecords('Ajay',false,2);
        Integer nopp=10;
        List<Opportunity> oppList= TestDataFactory.createOpportunityRecords(false,nopp);
        Integer d= nopp/oldAccounts.size();
        
        
        Test.startTest();
        insert oldAccounts;
        oldAccounts =[select Id,AnnualRevenue from Account order by CreatedDate DESC limit 2];
        for(Integer i=0;i<oldAccounts.size();i++){
            for(integer j=i*d;j<Math.min(i*d+d,oppList.size());j++){
                oppList[j].AccountId= oldAccounts[i].Id;
            }
        }
        insert oppList;
        List<account> stageAccounts =[select Id,AnnualRevenue from Account where Id in :oldAccounts];
        oppList=[select Id, amount, AccountId from Opportunity order by CreatedDate Desc limit :nopp];
        Opportunity op= oppList[(Integer)Math.floor(Math.random()*oppList.size())];
        Account na= [select Id, AnnualRevenue from Account where Id=:op.AccountId];
        delete op;
        
        Account dna= [select Id, AnnualRevenue from Account where Id=:op.AccountId];
        System.assertEquals(na.AnnualRevenue,dna.Annualrevenue+op.Amount);
        oppList.remove(oppList.indexOf(op));
        delete oppList;
        Test.stopTest();
         List<account> newAccounts =[select Id,AnnualRevenue from Account where Id in :oldAccounts];
         for(Account a : newAccounts)
        		System.assertEquals(a.annualRevenue,0);
        
    }
}