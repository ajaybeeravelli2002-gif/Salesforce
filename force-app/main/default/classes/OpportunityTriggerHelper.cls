public with sharing class OpportunityTriggerHelper {
    List<Opportunity> oldOpportunities;
    List<Opportunity> newOpportunities;
    public static Boolean isFirstOccurence=true;
    public OpportunityTriggerHelper(List<Opportunity> old,List<Opportunity> newrec){
		oldOpportunities=old;
        newOpportunities=newrec;
    }
    
    
    public void handleInsert(){
        Set<Id> accountids = new Set<Id>();
            for(Opportunity op : newOpportunities){
                    //Account newAccount = new Account();
                	//newAccount.Id= op.AccountId;
					accountids.add(op.AccountId);
            }
            List<AggregateResult> results=[Select AccountId,Sum(Amount) sumAmount from Opportunity where AccountId IN :accountids group by AccountId];
            List<Account> acclist= new List<Account>();
            for( AggregateResult ar : results){
				Account na=new Account();
                na.Id=(Id)ar.get('AccountId');
                na.AnnualRevenue=(Double)ar.get('sumAmount');
                acclist.add(na);
            }
            update acclist;
    }
   public void handleUpdate(){
      //old accountds updating
       List<Id> oldIds= new List<Id>();
       for(Opportunity op : oldOpportunities ){
			oldIds.add(op.AccountId);
       }
       // initialising the accounts prior updaing with Aggregate result value to avoid issue when the aggregate result has no data.
       Map<Id,Account> al= new Map<Id,Account>();
       for( Id i:oldIds){
           al.put(i,new Account(Id=i,AnnualRevenue=0));
       }
       List<AggregateResult> results=[Select AccountId, Sum(Amount) sumAmount from Opportunity where AccountId IN:oldIds group by AccountId];
       for(AggregateResult ar: results){
		   Account a= new Account();
           a.Id= (ID)ar.get('AccountId');
           a.AnnualRevenue= (Double)ar.get('sumAmount');
           al.put(a.Id,a);
       }
       update al.values();
       al.clear();
      //new accounts updating newIds
       List<Id> newIds= new List<Id>();
       for(Opportunity op : newOpportunities ){
			newIds.add(op.AccountId);
       }
       
       List<AggregateResult> nresults=[Select AccountId, Sum(Amount) sumAmount from Opportunity where AccountId IN:newIds group by AccountId];
       for(AggregateResult ar: nresults){
		   Account a= new Account();
           a.Id= (ID)ar.get('AccountId');
           a.AnnualRevenue= (Double)ar.get('sumAmount');
           al.put(a.Id,a);
       }
       update al.values();
       
   }
   //handling delete dml action
   public void handleDelete(){
       Set<Id> oldIds= new Set<Id>();
       for(Opportunity op : oldOpportunities ){
			oldIds.add(op.AccountId);
       }
       // initialising the accounts prior updaing with Aggregate result value to avoid issue when the aggregate result has no data.
       Map<Id,Account> al= new Map<Id,Account>();
       for( Id i:oldIds){
           al.put(i,new Account(Id=i,AnnualRevenue=0));
       }
       //p<Id,Account> oldMap= new Map<Id,Account>();
       
       List<AggregateResult> results=[Select AccountId, Sum(Amount) sumAmount from Opportunity where AccountId IN:oldIds group by AccountId];
       for(AggregateResult ar: results){
		   Account a= new Account();
           a.Id= (ID)ar.get('AccountId');
           a.AnnualRevenue= (Double)ar.get('sumAmount');
           al.put(a.Id,a);
       }
       update al.values();
   }
}